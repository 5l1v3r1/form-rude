begin
  require 'formrude/ui/console/shell/shell_core'
  require 'formrude/ui/console/shell/shell_config'
  require 'formrude/ui/console/shell/history'
  require 'formrude/ui/console/shell/commands'
rescue Exception => e
  puts "\n[!] Error from File: #{__FILE__} : #{e}\n\n"
end



#require_list = Dir.glob("../../../../lib/formrude/ui/console/shell/*.rb").map {|lib| lib.split("/").last.gsub(".rb" , "")}
#require_list.each do |lib|
#  require "../../../../lib/formrude/ui/console/shell/#{lib}"
#end


