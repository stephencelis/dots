# Require this file to add some capricious playfulness to your iterations.

Dots["."] = Proc.new { "\e[%dm.\e[0m" % [rand(10) + 30] }
Dots["F"] = Proc.new { "\e[%dmF\e[0m" % [rand(10) + 30] }
Dots["E"] = Proc.new { "\e[%dmE\e[0m" % [rand(10) + 30] }
