
require_list = Dir.glob("lib/formrude/ui/console/commands/*.rb").map {|lib| lib.split("/").last.gsub(".rb" , "")}
require_list.each do |lib|
  require "lib/formrude/ui/console/commands/#{lib}"
end


module FormRude
module Ui
module Console
module Shell
module Commands

  #
  # [CommandsCore] class calling all commands
  #
  class CommandsCore

    def initialize

    end


    def cmd_show

    end

  end

end
end # Shell
end # Console
end # UI
end # FormRude
