# # base.html
# block "head" do
#   %script{:type => "text/javascript", :src => "/mootools-core.js"}
# end
# 
# # index.html
# 
# - extends "base.html"

class Rango
  module Templates
    class Template
      attr_reader :template, :context
      def initialize(template, context)
        @template = template
        @context  = extend_context(context)
      end

      def render
        path = self.find(self.template)
        raise TemplateNotFound.new(template, Project.settings.template_dirs) if path.nil?
        file = File.new(path)
        $extends = nil #######
        value = self.engine.render(file, context)
        if $extends
          Rango.logger.debug("Extends call: #{$extends}")
          value = self.class.new($extends, self.context).render
        end
        return value
      end
      
      def extend_context(context)
        class << context
          include TemplateHelpers
          attr_accessor :template
        end
        context.template = self
        return context
      end
      
      # the template which doesn't contains extends is top level
      attribute :top_level, true
      def top_level?
        @top_level
      end

      def engine
        # TODO: test if Project.settings.template_engine nil => useful message
        # TODO: maybe more template engines?
        engine_name = Project.settings.template_engine
        Rango.import("templates/adapters/#{engine_name}.rb")
        engine_class = Rango::Templates.engine(engine_name)
        engine_class.new
      rescue LoadError
        Rango.logger.fatal("Template engine #{engine_name} can't be loaded.")
        raise Error406.new(self.params)
      end

      def find(template)
        Project.settings.template_dirs.each do |directory|
          path = File.join(directory, template)
          if File.exist?(path)
            return path
          elsif first = Dir["#{path}.*"].first
            return first
          end
        end
        return nil
      end
    end

=begin
At the begining we have a template which probably contains extends call.
We need to find the top level template. Top level template doesn't extend another template.
So ... Render all of them and if the aren't top-level, just save the blocks but doesn't render anything.
=end

=begin
Pruser je s navratovyma hodnotama bloku
Slo by predefinovat v Hamlu
=end
    module TemplateHelpers
      # TODO: this is haml specific
      # TODO: take capture_erb from merb-core
      # TODO: replace by capture_haml
      def capture(&block)
        # first we need to backup the old buffer
        # old_buffer   = @haml_buffer
        # @haml_buffer = Haml::Buffer.new
        old_buffer = @haml_buffer.buffer 
        @haml_buffer.buffer = ""
        block.call
        returned = @haml_buffer.buffer
        @haml_buffer.buffer = old_buffer
        return returned
      end
      
      # post/show.html: it's block is the block we like to see in output
      # post/base.html
      # base.html: here it will be rendered, so we need block to returns the correct block code
      def block(name, value = nil, &block)
        value = capture(&block) if value.nil? && block
        Rango.logger.debug("Value:")
        STDOUT.puts value
        $_blocks ||= Hash.new
        $_blocks[name] ||= value
        Rango.logger.inspect($_blocks)
        return $_blocks[name]
      end
    
      def extends(template)
        $extends = template #######
      end
    end
  end
end
