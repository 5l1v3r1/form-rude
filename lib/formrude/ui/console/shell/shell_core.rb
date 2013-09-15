
module FormRude
module Ui
module Console
module Shell

  #
  # [Prompt] class is a core for console's [Shell] *prompt*
  #
  class Prompt

    include FormRude::Ui::Console::Prints::Decoration

    def initialize
      @shell_config = FormRude::Ui::Console::Shell::Config.new
      p @context = Context.new
    end

    #
    # Start prompt
    #
    def start
      begin
        while true
          line = ""
          line = ::Readline.readline('FormRude'.white + ' -> '.light_red , true)
          @shell_config.history(line)
          @shell_config.run_command(line)

        end

      rescue Interrupt
        #puts_debug "Use 'exit' command to quit!"
        puts "Use 'exit' command to quit!"
        #retry
      end

    end

  end # Prompt

end # Shell
end # Console
end # UI
end # FormRude
