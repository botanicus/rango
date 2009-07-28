# encoding: utf-8

Given %r[^I have installed "(\w+)" executable$] do |executable|
  os.path.find do |directory|
    possibility = File.join(directory, executable)
    File.file?(possibility) && File.executable?(possibility)
  end
end

When %r[I run "(\w+)" generator] do |generator|
  @returned_value = rango :create, generator, "my-#{generator}"
  # Dir.chdir("my-#{generator}")
end

Then %r[the command should end successfuly] do
  @returned_value.should be_true
end

Then %r[I suspect thor tasks will run] do
  File.exist?("Thorfile").should be_true
  system("thor -T").should be_true
end

Then %r[it creates directory "([^\"]+)"$] do |name|
  pending
end
