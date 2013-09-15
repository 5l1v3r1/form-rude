
module FormRude
module Ui
module Console
module Shell

  #
  # [History] class handels all shell history stuff
  #
  class History
    attr_accessor :history_file

    def initialize
      history_file_init
    end

    #
    # Create/Initiate .history file if not exist
    #
    def history_file_init

      self.history_file = "#{FRAMEWORKDIR}/.history"

      if ! ::File.exists?("#{self.history_file}")
        File.new("#{self.history_file}", 'w+')
      end

      hist_file
    end

    #
    # To read history from history file
    #
    def hist_file
      hfile =  File.open("#{self.history_file}", 'r')
      hfile.each do |line|
        line.chomp!
        ::Readline::HISTORY.push(line)
      end
      hfile.close
    end

    #
    # Check if inserted line is repeated or not
    #
    def line_repeated?(line)
      if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
        Readline::HISTORY.pop
        return true
      else
        return false
      end
    end
  end

end # Shell
end # Console
end # UI
end # FormRude