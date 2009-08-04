# encoding: utf-8

require "blankslate"

class OS < BlankSlate
  # Takes ENV or another hash-like object and convert it into OS instance
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [ENV, Hash] ENV or another hash-like object
  # @return [OS] Instance of OS
  # @example
  #   OS.parse
  #   OS.parse("HOME" => "/Users/botanicus")
  def self.parse(original_env = ENV)
    input  = original_env.select { |key, value| key.match(/^[a-zA-Z][a-zA-Z_]*$/) }
    result = Hash.new
    input.each { |key, value| result[key.downcase.to_sym] = value }
    self.new(result, original_env)
  end

  attr_reader :env, :original_env
  def initialize(env, original_env = env)
    @env, @original_env = env, original_env
    self.keys.each do |key|
      if key.match(/(path|lib)$/)
        # OS.path
        # => ["/bin", "/usr/bin", "/sbin", "/usr/sbin"]
        define_singleton_method(key) do
          @env[key].split(":").uniq.sort
        end
      elsif @env[key].match(/^\d+$/)
        define_singleton_method(key) { @env[key].to_i }
      elsif @env[key].empty?
        define_singleton_method(key) { nil }
      else
        # OS.home
        # => "/Users/botanicus"
        define_singleton_method(key) do
          case value = @env[key]
          when /^\d+$/      then value.to_i
          when /^\d+\.\d+$/ then value.to_f
          when /^true$/i    then true
          when /^false$/i   then false
          when /^$/         then nil
          else              value
          end
        end
      end
    end
  end

  # Get value for given key or nil
  #
  # @author Botanicus
  # @since 0.0.3
  # @param [Symbol] Key
  # @return [OS] Instance of OS
  # @example
  #   os[:home]
  def [](key)
    self.send(key) if self.keys.include?(key.to_sym)
  end

  def ==(other)
    same_keys = self.keys == other.keys
    same_values = self.keys.all? { |key| self[key] == other[key] }
    same_keys && same_values
  end

  def keys
    @env.keys.sort
  end

  def inspect
    string = "#<OS keys=[%s]>"
    format = lambda { |key| "#{key}=#{self.send(key).inspect}" }
    inner  = self.keys.sort.map(&format).join(", ")
    string % inner
  end

  # TODO
  def root?
    self.uid.eql?(0)
  end

  private
  def method_missing(name, *args, &block)
    super(name, *args, &block) unless args.empty? && block.nil?
  end
end
