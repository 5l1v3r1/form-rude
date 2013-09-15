begin
  require 'formrude/ui/console/operations/http'
rescue Exception => e
  puts "\n[!] Error from File: #{__FILE__} : #{e}\n\n"
end


#require_list = Dir.glob("../../../../lib/formrude/ui/console/operations/*.rb").map {|lib| lib.split("/").last.gsub(".rb" , "")}
#require_list.each do |lib|
#  require "../../../../lib/formrude/ui/console/operations/#{lib}"
#end
