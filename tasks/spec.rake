# encoding: utf-8

desc "Run specs"
task :spec, :path do |task, args|
  rubylib = (ENV["RUBYLIB"] || String.new).split(":")
  libdirs = Dir["vendor/*/lib"]
  ENV["RUBYLIB"] = (libdirs + rubylib).join(":")
  exec "./script/spec --options spec/spec.opts #{args.path || "spec"}"
end

desc "Create stubs of all library files."
task "spec:stubs" do
  Dir.glob("lib/**/*.rb").each do |file|
    specfile = file.sub(/^lib/, "spec").sub(/\.rb$/, '_spec.rb')
    unless File.exist?(specfile)
      %x[mkdir -p #{File.dirname(specfile)}]
      %x[touch #{specfile}]
      puts "Created #{specfile}"
    end
  end
  (Dir.glob("spec/rango/**/*.rb") + ["spec/rango_spec.rb"]).each do |file|
    libfile = file.sub(/spec/, "lib").sub(/_spec\.rb$/, '.rb')
    if !File.exist?(libfile) && File.zero?(file)
      %x[rm #{file}]
      puts "Removed empty file #{file}"
    elsif !File.exist?(libfile)
      puts "File exists just in spec, not in lib: #{file}"
    end
  end
end
