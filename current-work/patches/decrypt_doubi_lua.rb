#!/usr/bin/env ruby
# Decrypts the signed Lua chunks used by the original Doubi Xiyou client.

require "fileutils"

DELTA = 0x9e3779b9
MASK = 0xffffffff
SIGNATURE = "dywl".b
KEY = "dywl523613713".b

def bytes_to_words(bytes)
  words = Array.new((bytes.bytesize + 3) / 4, 0)
  bytes.bytes.each_with_index do |byte, index|
    words[index / 4] |= byte << ((index % 4) * 8)
  end
  words
end

def decrypt_xxtea(bytes, key)
  values = bytes_to_words(bytes)
  key_words = bytes_to_words(key.ljust(16, "\0")[0, 16])
  count = values.length
  return bytes if count < 2

  y = values[0]
  sum = ((6 + 52 / count) * DELTA) & MASK

  until sum.zero?
    selector = (sum >> 2) & 3
    position = count - 1

    while position.positive?
      z = values[position - 1]
      mix = (((z >> 5) ^ ((y << 2) & MASK)) +
             ((y >> 3) ^ ((z << 4) & MASK))) & MASK
      mix ^= (((sum ^ y) & MASK) +
              ((key_words[(position & 3) ^ selector] ^ z) & MASK)) & MASK
      y = (values[position] - mix) & MASK
      values[position] = y
      position -= 1
    end

    z = values[count - 1]
    mix = (((z >> 5) ^ ((y << 2) & MASK)) +
           ((y >> 3) ^ ((z << 4) & MASK))) & MASK
    mix ^= (((sum ^ y) & MASK) + ((key_words[selector] ^ z) & MASK)) & MASK
    y = (values[0] - mix) & MASK
    values[0] = y
    sum = (sum - DELTA) & MASK
  end

  declared_size = values[-1]
  padded_size = values.length * 4
  unless declared_size.between?(padded_size - 7, padded_size - 4)
    raise "invalid decrypted length #{declared_size} for #{bytes.bytesize}-byte chunk"
  end

  values[0...-1].pack("V*").byteslice(0, declared_size)
end

source_root, output_root = ARGV
abort "usage: #{$PROGRAM_NAME} SOURCE_ROOT OUTPUT_ROOT" unless source_root && output_root

Dir.glob(File.join(source_root, "**", "*"), File::FNM_DOTMATCH).sort.each do |source|
  next unless File.file?(source)

  contents = File.binread(source)
  signed_chunk = contents.start_with?(SIGNATURE)
  packed_game = File.basename(source) == "game.bin"
  next unless signed_chunk || packed_game

  relative = source.delete_prefix("#{source_root}/")
  destination = File.join(output_root, relative)
  FileUtils.mkdir_p(File.dirname(destination))
  ciphertext = signed_chunk ? contents.byteslice(SIGNATURE.bytesize..) : contents
  File.binwrite(destination, decrypt_xxtea(ciphertext, KEY))
  puts relative
end
