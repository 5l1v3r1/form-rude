#!/usr/bin/env ruby

require 'readline'
require 'mechanize'
require 'pp'

=begin

FormRude ->help
FormRude ->show         # Lists all attributes in the current context
FormRude ->show post    # Lists post attributes context
FormRude ->show headers # Lists headers attributes context
FormRude ->show body    # Lists body attributes context
FormRude ->use body     # Changes context to the object referenced by the key body|headers
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
FormRude ->send 10  # send the post N times. default 1 time
FormRude ->back     # back one step
FormRude ->reset    # Reset all values to the original values
FormRude ->exit

------------------------------------
variable should be able to be filled from list file
f = File.read "name.list"
names = f.squeeze("\n").split.uniq

=end




module HTTP
  class PostParser

    attr_reader :post   # The original post
    attr_reader :parse  # Full parsed post (header and body). Can take :headers, :body . @return [Hash]

    def initialize(post)
      @post  = post.dup
      @parse = {:headers => headers , :body => body}
    end

    #
    # Parsing post headers and @return [Hash] of of {header => value}
    #
    def headers
      post = @post
      post_header = post.split("\n")[0] # To solve split(":") issue in POST http://domain.com
      post_header       = post_header.split(" ", 2)

      headers_grep      = post.scan(/(.*:.*)[\n\r]/)

      headers = [{post_header[0] => post_header[1]}]
      headers_grep.map do |h|
        val = h[0].split(":", 2)
        val[1].strip!

        headers << {val[0] => val[1]}
      end

      return headers
    end

    #
    # Parsing post body and @return [Hash] of {variable => value}
    #
    def body
      post = @post
      body = []

      body_grep = post.split(/&/)[1..-1]
      body_grep.map do |var|
        val = var.split("=", 2)
        val[1].chomp if val.last
        val[1].strip!

        body << {val[0] => val[1]}
      end

      return body
    end

  end # PostParser

end # HTTP


#
# A navigator stack to guide user console
#
class Context  # Operator Class

  attr_reader :current_context, :parent_context

  def initialize(current_context , parent_context)
    @current_context = current_context
    @parent_context  = parent_context
  end

  #
  # Tab completion array creator/builder: Will check the type of here and transform it into the list of keys to which the user can cd
  #
  def current_context_to_array
    case
      when self.current_context.kind_of?(Array)
        self.current_context.map { |item| item.keys }.join(' ') # TODO to be tested with join "\n"
      when self.current_context.kindof(Hash)
        self.current_context.keys.join(' ')
      else
        self.current_context.current_context_to_array
    end
  end

end # Context

class Commands

  def initialize(context)

    @context = context

  end

  def use

  end

  def show

  end

  def set

  end

  def send(times = 1)

  end


  def run_command(cmd)

  end
end


def main(post_file)
  file = File.read(post_file)
  parse = HTTP::PostParser.new(file)

  context = Context.new(parse,nil)

  command = ""

  while command != 'exit'
    Readline.readline('FormRude ->', true)

    #Readline.completion_proc = proc { |input| current_context.completions(input) }

    #puts "\n\n------Header--------\n\n"
    #puts parse.headers
    #puts "\n\n------Body-------\n\n"
    #puts parse.body
    #puts "\n\n------Parse-------\n\n"
    #p parse.parse[:headers]
    #puts "\n\n------Post-------\n\n"
    #pp parse.post
  end
end




post_file = ARGV[0]
if post_file && File.exists?(post_file)
  main(post_file)
else
  puts "error: you must provide a post file as an argument"
  exit 1
end


