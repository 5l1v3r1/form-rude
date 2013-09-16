#!/usr/bin/env ruby

require 'readline'
require 'mechanize'
require 'pp'
require 'terminal-table'

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

#
# colors
#
class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def light_red; colorize(self, "\e[1m\e[91m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def blue; colorize(self, "\e[1m\e[34m"); end
  def dark_blue; colorize(self, "\e[34m"); end
  def pur; colorize(self, "\e[1m\e[35m"); end
  def bold; colorize(self, "\e[1m"); end
  def underline; colorize(self, "\e[4m"); end
  def blink; colorize(self, "\e[5m"); end
  def light_cyan; colorize(self, "\e[1m\e[36m"); end
  def cyan; colorize(self, "\e[0;36;49mSS"); end
  def white; colorize(self, "\e[1m\e[97m"); end
  def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end



module HTTP
  class PostParser

    attr_reader :post   # The original post
    attr_reader :parse  # Full parsed post (header and body). Can take :headers, :body . @return [Hash]

    def initialize(post)
      @post  = post.dup
      @parse = [:headers => headers , :body => body , :full_post => [headers, body]]
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

  attr_accessor :current_context
  attr_accessor :parent_context

  def initialize(current_context , parent_context)
    @current_context = current_context
    @parent_context  = parent_context
  end

  #
  #
  #
  def chance_context(context = nil)
      if context == "back"
        self.parent_context
      elsif self.current_context.kind_of?(Array)
        pp current_context[0].keys
        self.parent_context = self.current_context[0].keys
        self.current_context[0][context.to_sym]
      elsif self.current_context.kind_of?(Hash)
        self.current_context.keys
      end
  end


  #
  # Tab completion array creator/builder: Will check the type of here and transform it into the list of keys to which the user can cd
  #
  def current_context_to_array
    case
      when self.current_context.kind_of?(Array)
        self.current_context.map { |item| item.keys }.join(' ') # TODO to be tested with join "\n"
      when self.current_context.kindof?(Hash)
        self.current_context.keys.join(' ')
      else
        self.current_context.current_context_to_array
    end
  end

end # Context

class Commands

  def initialize(context)
    @context = Context.new(context.parse, nil)
  end


  #
  # Show the contents
  #
  def cmd_show(value)
    value = nil if value == "show"

    case
      when value == "headers"
        hrows = []
        @context.current_context[0][:headers].map do |hash|
          hash.each do |_key , _val|
            _val = _val.scan(/.{100}/).join("\n") if _val.size > 150    # This line To fix table layout

            hrows << ["#{_key}".green , "#{_val}".white]
            hrows << :separator
          end
        end
        puts htable = Terminal::Table.new(:title => "Headers".bold.underline, :headings => ["Header".bold, "Value".bold], :rows => hrows)

      when value == "body"
        brows = []
        @context.current_context[0][:body].map do |hash|
          hash.each do |_key , _val|
            _val = _val.scan(/.{100}/).join("\n") if _val.size > 150    # This line To fix table layout

            brows << ["#{_key}".green, "#{_val}".white]
            brows << :separator
          end
        end
        puts btable = Terminal::Table.new(:title => "Body".bold.underline, :headings => ["Variable".bold, "Value".bold], :rows => brows)

      when value == "full_post"
        frows = []
        @context.current_context[0][:headers].map do |hash|
          hash.each do |_key , _val|
            _val = _val.scan(/.{100}/).join("\n") if _val.size > 150    # This line To fix table layout

            frows << ["#{_key}".green , "#{_val}".white]
            frows << :separator
          end
        end

        @context.current_context[0][:body].map do |hash|
          hash.each do |_key , _val|
            _val = _val.scan(/.{100}/).join("\n") if _val.size > 150    # This line To fix table layout

            frows << ["#{_key}".green, "#{_val}".white]
            frows << :separator
          end
        end
        puts htable = Terminal::Table.new(:title => "Full post".bold.underline, :headings => ["Value".bold, "Value".bold], :rows => frows)
      else
        pp @context.current_context
    end

  end

  #
  # cd
  #
  def cmd_use(value)
    puts "[!] Missing arguament!" if value == "use"
    value = nil if value == "use"
     new_context = @context.chance_context(value).map {|key| key.keys[0]}
     @context.current_context =  new_context
  end

  def cmd_set

  end

  def cmd_send(times = 1)
    times = times.to_i
    times.to_i.times do
      puts "send post #{times}"
    end
  end

  def cmd_back(cmd)
    @context.current_context = @context.parent_context
    #@context.parent_context
  end

  def cmd_exit(value = nil)
    exit
  end

  def current_active_context
    @context.current_context_to_array
  end

  def is_command?(command)
    self.respond_to?("cmd_#{command.first}")
  end

  def run_command(command)
    command =  command.split

    if self.respond_to?("cmd_#{command.first}")
      send("cmd_#{command.first}", command.last)
    elsif command.empty? or command.nil?
      # Do Nothing!
    else
      puts "Unkown command!"
    end
    #pp @context.current_context
  end


end # Commands


def main(post_file)
  file = File.read(post_file)
  parse = HTTP::PostParser.new(file)
  context = parse
  @commands = Commands.new(context)


  # File summary
  puts "[+] ".green + "File Summary".white
  puts "- ".dark_green + "Post file name: " + "#{post_file.split('/').last}".bold
  puts "- ".dark_green + "Number of headers: " + "#{parse.headers.length}".bold   + " headers"
  puts "- ".dark_green + "Number of variables: " + "#{parse.body.length}".bold    + " variables"
  puts "\n\n"

  command = ""

  while true

    command =  Readline.readline('FormRude ->', true)

    @commands.run_command(command)

    puts "\n\n------Headers-------\n\n"
    puts parse.headers
    puts parse.headers.length
    puts "\n\n------Body-------\n\n"
    puts parse.body
    #puts parse.body.length
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


