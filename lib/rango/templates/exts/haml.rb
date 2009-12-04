# encoding: utf-8

# Option default_attributes
# 
# A hash of default attributes for tags (`{tag => {attribute => default_value}}`).
# Attributes of each tag will reverse merged with his default attributes, so you
# don't have to write over and over that script tag has attribute `type` with value
# `text/javascript`. For example, `%script` compiles to `<script type="text/javascript"></script>`.
# Defaults to `{:script => {:type => "text/javascript"}, :form => {:method => "POST"}}`

module Haml
  class Engine
    alias_method :__initialize__, :initialize
    def initialize(template, options = Hash.new)
      __initialize__(template, options)
      @options[:default_attributes] = Hash.new
      # symbolize keys
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
end
