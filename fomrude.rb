#!/usr/bin/env ruby

require 'readline'
require 'mechanize'
require 'pp'

=begin

FormRude ->help
FormRude ->show post
FormRude ->show headers
FormRude ->show body
FormRude ->use body
FormRude (body)->show       >>> Should shows: variable = value
FormRude (body)->show variables
FormRude (body)->show values
FormRude (body)->set ctl00%24cphMain%24ctl00%24txtFullName Sabri

FormRude ->use headers
FormRude (body)->show       >>> Should shows: header = value
FormRude (body)->show headers
FormRude (body)->show values
FormRude (body)->set User-Agent Google-chrome


FormRude (|headers|body)->send
FormRude ->reset
FormRude ->send 10 >> default 1
FormRude ->back  >> back on step
FormRude ->

------------------------------------
variable should be able to be filled from list file
f = File.read "name.list"
names = f.squeeze("\n").split.uniq



=end




module HTTP
  class PostParser

    attr_reader :post , :parse

    def initialize(post)
      @post  = post.dup
      @parse = {:headers => headers , :body => body}
    end

    #
    # Parsing post headers and @return [Hash] of of {header => value}
    #
    def headers
      post = @post
      headers_grep = post.scan(/(.*:.*)[\n\r]/)
      headers_grep.map do |h|
        val = h[0].split(":", 2)
        val[1].strip!

        {val[0] => val[1]}
      end
    end

    #
    # Parsing post body and @return [Hash] of {variable => value}
    #
    def body
      post = @post
      body_grep = post.split(/&/)[1..-1]
      body_grep.map do |var|
        val = var.split("=", 2)
        val[1].chomp if val.last
        val[1].strip!

        {val[0] => val[1]}
      end
    end

  end

  class Builder

    def build_headers(header={})

    end

    def build_body(body={})

    end

    def generate_post
      [
          build_headers,
          "",
          build_body
      ]
    end

  end
end


class Context

  attr_reader :here, :parent_context

  def initialize(here , parent_context)
    @here = here
    @parent_context = parent_context
  end

  # cd value
  def use(value)
    item = item_at(value)
    if item.nil?
      nil
    else
      Context.new(item,self)
    end
  end

  # cd ..
  def back
    self.parent_context
  end

  def completions(input)
    self.split(/\s+/).grep(/^#{input}/)
  end
end


def main(post_file)
  file = File.read(post_file)
  parse = HTTP::PostParser.new(file)
  command = ""

  current_context = Context.new(parse.parse, nil)

  while command != 'exit'
    Readline.readline('FormRude ->', true)
    #puts "\n\n------Header--------\n\n"
    #pp parse.headers
    #puts "\n\n------Body-------\n\n"
    #pp parse.body
    #puts "\n\n------Parse-------\n\n"
    #pp parse.parse
    #puts "\n\n------Post-------\n\n"
    #pp parse.post
    #Readline.completion_proc = proc { |input| current_context.completions(input) }
    current_context = execute_command(command.strip, current_context)
  end
end

def execute_command(command, current_context)
  case command
    when /^help$/
      commands =
          {
              'help'    => 'Help menu - Show This screen',
              'show' => 'Displays modules of a given type, or all modules',
              'use'  => 'Selects a module by name',
              'set' =>  'Set a value for current variable',
              'exit' => 'Exit the console'
          }
      puts "\nHelp menu"
      puts '=' * 'Help menu'.length + "\n\n"
      puts "Command \t\t Description"
      puts '-' * 'Command'.length + " \t\t " + '-' * 'Description'.length
      commands.each {|key| puts "#{key} \t\t #{commands[key]}"}
      puts "\n\n"
    when /^back$/
      back
      puts "back one step"
  end
end



post_file = ARGV[0]
if post_file && File.exists?(post_file)
  main(post_file)
else
  STDERR.puts "error: you must provide a post file as an argument"
  exit 1
end










