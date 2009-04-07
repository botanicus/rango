# I know, I know, we have Rubigen, Templater and others, but Rango needs something really simple, so user can start work immediately and can't study bloated docs

# @future 0.0.3 It's just a prototype now. But it will be available in 0.0.3. Stay tuned!
class Rango
  class Generator
    # context can me something like {name: ARGV.first, modname: ARGV.first.snake_case}
    def initialize(path, context = Hash.new)
      @path = path
      @context = context
    end

    def generate!
      if Dir.exist?(@path)
        Find.find(@path) do |file|
          # mkdir -p if directory
          # gsub co
          substitute(file)
        end
      else
      end
    end

    def substitute(file)
      content = File.read(file)
      @context.each do |key, value|
        # replace {{ name }}
        # TODO: the pattern should be configurable
        content.gsub!(%r[\{\{\s*#{key}\s*\}\}])
      end
    end
  end
end