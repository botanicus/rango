# encoding: utf-8

class Yardoc < Thor
  desc "generate", "Generate Yardoc documentation for rango."
  def generate
    # template, textile or rdoc or md
    # -t: template [available: default, javadoc]
    # -m: markup style used in documentation [available: textile, markdown, rdoc]
    %x[yardoc -r README.textile lib/rango.rb lib/rango/**/*.rb -t default -o doc/head]
  end

  desc "clean", "Remove the documentation"
  def clean
    %x[rm -rf doc]
  end
end