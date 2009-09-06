# encoding: utf-8

module Rango
  module CLI
    def yes?(question)
      print "#{question} [Y/n] "
      values = {"y" => true, "n" => false}
      input  = STDIN.readline.chomp.downcase
      values[input]
    end

    def ask(question)
      print "#{question} "
      STDIN.readline.chomp
    end
  end
end
