# encoding: utf-8

desc "Install Git hooks"
task :hooks do
  if Dir.exist?(".git/hooks")
    abort "You must remove .git/hooks first"
  else
    # NOTE: Do not symlink them, otherwise git will add samples
    cp_r "support/hooks", ".git/hooks"
    Dir[".git/hooks/*"].each do |hook|
      sh "chmod +x #{hook}"
    end
  end
end
