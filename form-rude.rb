#!/usr/bin/env ruby
#
#
#


#
# Environment path settings
#
framework_base = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
FRAMEWORKDIR = File.join(File.expand_path(File.dirname(framework_base)))
$:.unshift(File.join(File.expand_path(File.dirname(framework_base)), 'lib'))

require 'formrude'
require 'readline'
require 'pp'



post_file = ARGV[0]
if post_file and File.exists?(post_file)
  file = File.read(post_file)
else
  puts "[!] ".red.bold + "error: you must provide a post file as an argument"
  puts "ex. " + "ruby #{$PROGRAM_NAME.split("/").last}" + "post-file.txt"
  exit 1
end

parse = FormRude::Ui::Console::Operations::HTTP::PostParser.new(file)

# File summary
puts "[+] ".green + "File Summary".white
puts "- ".dark_green + "Post file name: "      + "#{post_file.split('/').last}".bold
puts "- ".dark_green + "Number of headers: "   + "#{parse.headers.length}".bold + " headers"
puts "- ".dark_green + "Number of variables: " + "#{parse.body.length}".bold    + " variables"
puts ""

FormRude::Ui::Console::Shell::Prompt.new.start





