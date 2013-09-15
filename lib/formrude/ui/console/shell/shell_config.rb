#require 'formrude/ui/console/shell/commands'

module FormRude
module Ui
module Console
module Shell

  #
  # [Config] class a central placeholder for general console configurations
  #
  class Config
    #include FormRude::Ui::Console::Shell::Commands


    def initialize
      require 'readline'
      @history = FormRude::Ui::Console::Shell::History.new
      @file    = File.open(@history.history_file, 'a')

      @context = Context.new
    end

    #
    # Shell history configurations
    #
    def history(line)
      @file.puts(line) unless @history.line_repeated?(line)
    end

    #
    # Send command to be executed
    #
    def run_command(command)
      puts command
    end

  end # Config

end # Shell
end # Console
end # UI
end # FormRude

