# encoding: utf-8

# template, textile or rdoc or md
# -t: template [available: default, javadoc]
# -m: markup style used in documentation [available: textile, markdown, rdoc]
desc "Generate Yardoc documentation for rango"
task :yardoc do
  sh "yardoc -r README.textile lib/**/*.rb -t default"
end
