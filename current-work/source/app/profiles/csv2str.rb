#!/usr/local/bin/ruby -w

require 'pathname'

# csv转换为lua str
def csv2str(filename)
  basename = filename.to_s.split('.')[0]
  outfile = File.new(basename+'.lua', 'w+')

  str= 'local M=[['
  File.readlines(filename).each do |line|
    line = line.gsub('"','\"')
    str += line
  end
  str +=']]'
  outfile.puts str
  outfile.puts 'return M'
  outfile.flush
  outfile.close
end

# 遍历所有文件,并转换
def traverse_dir(file_path)
  if File.directory? file_path
    Dir.foreach(file_path) do |file|
      if file !='.' and file !='..'
        traverse_dir(file_path+'/'+file)
        ext = file[/\.[^\.]+$/]
        if ext=='.csv'
          csv2str(file)
        end
      end
    end
  end
end

path = Pathname.new(File.dirname(__FILE__)).realpath

#运行
traverse_dir(path)
