# coding: utf-8

class Hooks < Thor
  # TODO: force option
  def all
    if File.directory?(".git/hooks")
      abort "You must remove .git/hooks first"
    else
      FileUtils.cp_r("support/hooks", ".git/hooks")
    end
  end
  
  def install(name)
    if File.file?(".git/hooks/#{name}")
      abort "File .git/hooks/#{name} already exists. Please remove it first."
    else
      FileUtils.cp("support/hooks/#{name}", ".git/hooks/#{name}")
    end
  end
end