


#module FormRude
#module UI
#module Console
#module Prints

  class String
    def red; colorize(self, "\e[1m\e[31m"); end
    def light_red; colorize(self, "\e[1m\e[91m"); end
    def green; colorize(self, "\e[1m\e[32m"); end
    def dark_green; colorize(self, "\e[32m"); end
    def yellow; colorize(self, "\e[1m\e[33m"); end
    def blue; colorize(self, "\e[1m\e[34m"); end
    def dark_blue; colorize(self, "\e[34m"); end
    def pur; colorize(self, "\e[1m\e[35m"); end
    def bold; colorize(self, "\e[1m"); end
    def underline; colorize(self, "\e[4m"); end
    def blink; colorize(self, "\e[5m"); end
    def light_cyan; colorize(self, "\e[1m\e[36m"); end
    def cyan; colorize(self, "\e[0;36;49mss"); end
    def white; colorize(self, "\e[1m\e[97m"); end
    def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
  end

#end # Prints
#end # Console
#end # UI
#end # FormRude

