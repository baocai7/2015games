#!/usr/bin/env ruby

DELTA = 0x9e3779b9
MASK = 0xffffffff
KEY = "dywl523613713".b

def bytes_to_words_with_length(bytes)
  words = Array.new((bytes.bytesize + 3) / 4, 0)
  bytes.bytes.each_with_index do |byte, index|
    words[index / 4] |= byte << ((index % 4) * 8)
  end
  words << bytes.bytesize
end

def encrypt_xxtea(bytes, key)
  values = bytes_to_words_with_length(bytes)
  key_words = Array.new(4, 0)
  key.ljust(16, "\0")[0, 16].bytes.each_with_index do |byte, index|
    key_words[index / 4] |= byte << ((index % 4) * 8)
  end
  count = values.length
  rounds = 6 + 52 / count
  sum = 0
  z = values[count - 1]
  rounds.times do
    sum = (sum + DELTA) & MASK
    selector = (sum >> 2) & 3
    (0...(count - 1)).each do |position|
      y = values[position + 1]
      mix = (((z >> 5) ^ ((y << 2) & MASK)) + ((y >> 3) ^ ((z << 4) & MASK))) & MASK
      mix ^= (((sum ^ y) & MASK) + ((key_words[(position & 3) ^ selector] ^ z) & MASK)) & MASK
      values[position] = (values[position] + mix) & MASK
      z = values[position]
    end
    y = values[0]
    position = count - 1
    mix = (((z >> 5) ^ ((y << 2) & MASK)) + ((y >> 3) ^ ((z << 4) & MASK))) & MASK
    mix ^= (((sum ^ y) & MASK) + ((key_words[(position & 3) ^ selector] ^ z) & MASK)) & MASK
    values[position] = (values[position] + mix) & MASK
    z = values[position]
  end
  values.pack("V*")
end

source, destination = ARGV
abort "usage: #{$PROGRAM_NAME} INPUT OUTPUT" unless source && destination
plaintext = File.binread(source)
File.binwrite(destination, encrypt_xxtea(plaintext, KEY))
puts "encrypted #{plaintext.bytesize} bytes to #{destination}"
