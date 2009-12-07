# encoding: utf-8

# === Helpers === #
def submodules(&block)
  File.foreach(File.join(File.dirname(__FILE__), "..", ".gitmodules")) do |line|
    if line.match(%r{submodule "(.+)"})
      block.call($1)
    end
  end
end

# === Tasks === #
namespace :submodules do
  desc "Init submodules"
  task :init do
    sh "git submodule init"
  end

  desc "Update submodules"
  task :update do
    submodules do |path|
      if File.directory?(path) && File.directory?(File.join(path, ".git"))
        Dir.chdir(path) do
          puts "=> #{path}"
          sh "git reset --hard"
          sh "git fetch"
          sh "git reset origin/master --hard"
          puts
        end
      end
    end
  end
end
