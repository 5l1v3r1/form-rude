
module FormRude
module Ui
module Console
module Prints

  #
  # Decoration module Decorate application outputs
  #
  module Decoration

    # Terminal dimensions. @return [height, width]
    def terminal_size
      begin
        Readline.get_screen_size
      rescue
        puts_debug "I can't detect you commandline environment!"
      end
    end

    # Info print
    def puts_info(str = '')
      puts '[+]'.green + "#{str}"
    end

    # Error print
    def puts_err(str = '')
     puts '[-] '.red + "#{str}"
    end

    # Debug print
    def puts_debug(str = '')
      puts '[!] '.light_yellow + "#{str}"
    end

    # Warning print
    def puts_fatal(str = '')
      puts '[!] '.colorize( :light_blue ).colorize( :background => :red ).blink + "#{str}".colorize( :light_blue ).colorize( :background => :red )
    end

  end # Decoration

end # Print
end # Console
end # Ui
end # XSS
 
