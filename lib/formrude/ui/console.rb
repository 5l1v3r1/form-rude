begin
  require 'formrude/ui/console/prints'
  require 'formrude/ui/console/shell'
  require 'formrude/ui/console/context'
  require 'formrude/ui/console/operations'
rescue Exception => e
  puts "\n[!] Error from File: #{__FILE__} : #{e}\n\n"
end



#require_list = Dir.glob("../../../lib/formrude/ui/console/*.rb").map {|lib| lib.split("/").last.gsub(".rb" , "")}
#require_list.each do |lib|
#  require "../../../lib/formrude/ui/console/#{lib}"
#end



