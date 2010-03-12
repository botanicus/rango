# encoding: utf-8

# Option default_attributes
#
# A hash of default attributes for tags (`{tag => {attribute => default_value}}`).
# Attributes of each tag will reverse merged with his default attributes, so you
# don't have to write over and over that script tag has attribute `type` with value
# `text/javascript`. For example, `%script` compiles to `<script type="text/javascript"></script>`.
# Defaults to `{script: {type: "text/javascript"}, form: {method: "POST"}}`

module Haml
  class Engine
    alias_method :__initialize__, :initialize
    def initialize(template, options = Hash.new)
      __initialize__(template, options)
      @options[:default_attributes] ||= Hash.new
      @options[:default_attributes] = @options[:default_attributes].inject(Hash.new) do |options, pair|
        options.merge(pair.first.to_sym => pair.last)
      end
    end
  end

  module Precompiler
    alias_method :__prerender_tag__, :prerender_tag
    def prerender_tag(name, self_close, attributes)
      # merge given attributes with default attributes from options
      if default_attributes = @options[:default_attributes][name.to_sym]
        attributes = default_attributes.merge(attributes)
      end
      __prerender_tag__(name, self_close, attributes)
    end
  end

  class Buffer
    alias_method :__open_tag__, :open_tag
    def open_tag(name, self_closing, try_one_line, preserve_tag, escape_html, class_id,
                 nuke_outer_whitespace, nuke_inner_whitespace, obj_ref, content, *attributes_hashes)
      if Tilt::HamlTemplate.options[:default_attributes][name.to_sym]
        attributes_hashes.first.merge!(Tilt::HamlTemplate.options[:default_attributes][name.to_sym])
      end
      __open_tag__(name, self_closing, try_one_line, preserve_tag, escape_html, class_id,
                    nuke_outer_whitespace, nuke_inner_whitespace, obj_ref, content, *attributes_hashes)
    end
  end
end
