class Rango
  class DependencyStrategy
  end

  class GitDependencyStrategy < DependencyStrategy
    attr_accessor :repo
    def initialize(repo)
      @repo = repo
    end

    def get
      %x[git clone #{self.repo}]
    end
  end
  
  class GithubDependencyStrategy < GitDependencyStrategy
    def initialize(path)
      @repo = "git://github.com/#{path}.git"
    end
  end
  
  class GemDependencyStrategy < DependencyStrategy
    def initialize(gemname, version = nil)
      @gemname = gemname
      @version = version
    end
    
    def get
      part = File.join(Gem.path, "cache", @gemname)
      if @version
        path = "#{part}-#{@version}.gem"
      else
        path = Dir["#{part}-*.gem"].last
      end
      %x[cp "#{path}" .]
    end
  end
end