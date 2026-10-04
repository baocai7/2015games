#!/usr/local/bin/ruby -w
#encoding=UTF-8

require 'pathname'

=begin
local M = {
  {"id","name"},
  {"1","测试"},
}
=end

def csv2table(filename)
  basename = filename.to_s.split('.')[0]
  outfile = File.new(basename+'.lua', 'w+')

  first_line_items = nil
  outfile.puts 'local M={'

  index_line = 0
  File.readlines(filename).each do |line|

    line = line.chomp
    line.force_encoding('UTF-8')
    line = line.gsub('"','\"')
    items = line.to_s.split(',')

    if index_line==0 then
      first_line_items = items
    end

    str = ' {'
    items.each do |item|
      str += '"'+item.to_s+'",'
    end
    str += '},'
    outfile.puts str

    index_line+=1
  end

  #创建索引
  if first_line_items!=nil then
    str = ' ["index"] = {'
    index_item = 1
    first_line_items.each do |item|
      str += "[\"#{item}\"]=" + index_item.to_s+','
      index_item += 1
    end

    str += '}'
    outfile.puts str
  end

  outfile.puts '}'
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
          csv2table(file)
        end
      end
    end
  end
end

path = Pathname.new(File.dirname(__FILE__)).realpath

#运行
traverse_dir(path)