begin
  require 'formrude/ui/console/context/context'
rescue Exception => e
  puts "\n[!] Error from File: #{__FILE__} : #{e}\n\n"
end




#require_list = Dir.glob("../../../../lib/formrude/ui/console/context/*.rb").map {|lib| lib.split("/").last.gsub(".rb" , "")}
#require_list.each do |lib|
#  require "../../../../lib/formrude/ui/console/context/#{lib}"
#end



