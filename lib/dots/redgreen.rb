# Require this file to add some red and green flair to your iterations.

Dots["."] = "\e[32m#{Dots["."]}\e[0m"
Dots["F"] = "\e[31m#{Dots["F"]}\e[0m"
Dots["E"] = "\e[31m#{Dots["E"]}\e[0m"

Dots.module_eval do
  # Overrides Dots#summary with some red and green flair.
  def summary(passed, failed, erred)
    code = failed + erred == 0 ? "2" : "1"
    "\e[3%dm%d total, %d passed, %d failed, %d erred\e[0m" %
      [code, passed + failed + erred, passed, failed, erred]
  end
end
