#!/usr/bin/env ruby
# Unpacks an encrypted Android Backup (.ab) file into its tar payload.

require "openssl"
require "zlib"

source, destination, password = ARGV
abort "usage: #{$PROGRAM_NAME} BACKUP.ab OUTPUT.tar [PASSWORD]" unless source && destination
password ||= ""

def decrypt_aes_cbc(ciphertext, key, iv)
  cipher = OpenSSL::Cipher.new("AES-256-CBC")
  cipher.decrypt
  cipher.key = key
  cipher.iv = iv
  cipher.update(ciphertext) + cipher.final
end

File.open(source, "rb") do |file|
  magic = file.gets
  abort "not an Android Backup file" unless magic == "ANDROID BACKUP\n"

  version = Integer(file.gets, 10)
  compressed = file.gets.strip == "1"
  encryption = file.gets.strip
  abort "unsupported backup encryption: #{encryption}" unless encryption == "AES-256"

  user_salt = [file.gets.strip].pack("H*")
  checksum_salt = [file.gets.strip].pack("H*")
  rounds = Integer(file.gets, 10)
  user_iv = [file.gets.strip].pack("H*")
  encrypted_master_blob = [file.gets.strip].pack("H*")

  user_key = OpenSSL::PKCS5.pbkdf2_hmac(password, user_salt, rounds, 32, "SHA1")
  master_blob = decrypt_aes_cbc(encrypted_master_blob, user_key, user_iv)

  offset = 0
  read_field = lambda do
    size = master_blob.getbyte(offset)
    raise "invalid master-key blob" unless size
    offset += 1
    value = master_blob.byteslice(offset, size)
    raise "truncated master-key blob" unless value&.bytesize == size
    offset += size
    value
  end

  master_iv = read_field.call
  master_key = read_field.call
  stored_checksum = read_field.call
  checksum_password = master_key.bytes.map(&:chr).join.encode("UTF-8")
  calculated_checksum = OpenSSL::PKCS5.pbkdf2_hmac(
    checksum_password, checksum_salt, rounds, stored_checksum.bytesize, "SHA1"
  )
  abort "backup password is incorrect" unless stored_checksum == calculated_checksum

  payload = decrypt_aes_cbc(file.read, master_key, master_iv)
  payload = Zlib::Inflate.inflate(payload) if compressed
  File.binwrite(destination, payload)
  puts "Android Backup v#{version}: wrote #{payload.bytesize} bytes to #{destination}"
end
