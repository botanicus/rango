# encoding: utf-8

desc "Install Git hooks"
task :hooks do
  if Dir.exist?(".git/hooks")
    abort "You must remove .git/hooks first"
  else
    # do not symlink them, otherwise git will add samples
    # FIXME: permissions
    cp_r "support/hooks", ".git/hooks"
  end
end
