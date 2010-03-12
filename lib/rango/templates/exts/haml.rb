# encoding: utf-8

# Option default_attributes
#
# A hash of default attributes for tags (`{tag => {attribute => default_value}}`).
# Attributes of each tag will reverse merged with his default attributes, so you
# don't have to write over and over that script tag has attribute `type` with value
# `text/javascript`. For example, `%script` compiles to `<script type="text/javascript"></script>`.
# Defaults to `{script: {type: "text/javascript"}, form: {method: "POST"}}`

Tilt::HamlTemplate.options ||= Hash.new

module Haml
  module Precompiler
    alias_method :__prerender_tag__, :prerender_tag
    def prerender_tag(name, self_close, attributes)
      # merge given attributes with default attributes from options
      if default_attributes = Tilt::HamlTemplate.options[:default_attributes]
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
