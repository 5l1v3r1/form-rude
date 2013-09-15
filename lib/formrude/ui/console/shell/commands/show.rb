#
#
#


module FormRude
module Ui
module Console
module Shell
module Commands
  class Show

    def initialize
      @hrows = []
      @brows = []
      @frows = []
    end

    def show_headers
      @context.current_context[0][:headers].map do |hash|
        hash.each do |_key , _val|
          _val = _val.scan(/.{100}/).join("\n") if _val.size > 150    # This line To fix table layout

          @hrows << ["#{_key}".green , "#{_val}".white]
          @hrows << :separator
        end
      end

      #htable = Terminal::Table.new(:title => "Headers".bold.underline, :headings => ["Header".bold, "Value".bold], :rows => @hrows)
    end

    def show_body
      @context.current_context[0][:body].map do |hash|
        hash.each do |_key , _val|
          _val = _val.scan(/.{100}/).join("\n") if _val.size > 150    # This line To fix table layout

          @brows << ["#{_key}".green, "#{_val}".white]
          @brows << :separator
        end
      end

      #btable = Terminal::Table.new(:title => "Body".bold.underline, :headings => ["Variable".bold, "Value".bold], :rows => @brows)
    end

    def show_full
      @hrows << [show_headers , show_body]
    end

    def action(value)
      value = nil if value == "show"

      case
        when value == "headers"
          puts htable = Terminal::Table.new(:title => "Headers".bold.underline, :headings => ["Header".bold, "Value".bold], :rows => @hrows)
        when value == "body"
          puts btable = Terminal::Table.new(:title => "Body".bold.underline, :headings => ["Variable".bold, "Value".bold], :rows => @brows)
        when value == "full_post"
          puts htable = Terminal::Table.new(:title => "Full post".bold.underline, :headings => ["Value".bold, "Value".bold], :rows => @frows)
        else
          pp @context.current_context
      end

    end

  end
end # Commands
end # Shell
end # Console
end # UI
end # FormRude
