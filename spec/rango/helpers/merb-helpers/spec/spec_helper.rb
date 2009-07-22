# encoding: utf-8

require "rubygems"
require "spec"
require "merb-core"
require File.join(File.dirname(__FILE__),"..",'lib',"merb-helpers")
require "date"
require "webrat"

# Please read merb_helpers_form_spec.rb
# for more info on how to test helpers
# full stack specs are required
# use the app in spec/fixture to test helpers


default_options = {
  :environment => 'test',
  :adapter     => 'runner',
  :merb_root   => File.dirname(__FILE__) / 'fixture',
  :log_file    => File.dirname(__FILE__) / "merb_test.log"
}
options = default_options.merge($START_OPTIONS || {})

Rango.disable(:initfile)
Rango.start_environment(options)

def unload_merb_helpers
  Rango.class_eval do
    remove_const("Helpers") if defined?(Rango::Helpers)
  end
end

def reload_merb_helpers
  unload_merb_helpers
  load(MERB_HELPERS_ROOT + "/lib/merb-helpers.rb")
  Rango::Helpers.load
end

class FakeErrors

  def initialize(model)
    @model = model
  end

  def on(name)
    name.to_s.include?("bad")
  end

end

class FakeColumn
  attr_accessor :name, :type

  def initialize(name, type)
    @name, @type = name, type
  end

end




# -- Global custom matchers --

# A better +be_kind_of+ with more informative error messages.
#
# The default +be_kind_of+ just says
#
#   "expected to return true but got false"
#
# This one says
#
#   "expected File but got Tempfile"

module Rango
  module Test
    module RspecMatchers
      class IncludeLog
        def initialize(expected)
          @expected = expected
        end

        def matches?(target)
          target.log.rewind
          @text = target.log.read
          @text =~ (String === @expected ? /#{Regexp.escape @expected}/ : @expected)
        end

        def failure_message
          "expected to find `#{@expected}' in the log but got:\n" <<
          @text.map {|s| "  #{s}" }.join
        end

        def negative_failure_message
          "exected not to find `#{@expected}' in the log but got:\n" <<
          @text.map {|s| "  #{s}" }.join
        end

        def description
          "include #{@text} in the log"
        end
      end

      class BeKindOf
        def initialize(expected) # + args
          @expected = expected
        end

        def matches?(target)
          @target = target
          @target.kind_of?(@expected)
        end

        def failure_message
          "expected #{@expected} but got #{@target.class}"
        end

        def negative_failure_message
          "expected #{@expected} to not be #{@target.class}"
        end

        def description
          "be_kind_of #{@target}"
        end
      end

      def be_kind_of(expected) # + args
        BeKindOf.new(expected)
      end

      def include_log(expected)
        IncludeLog.new(expected)
      end
    end

    module Helper
      def running(&block) block; end

      def executing(&block) block; end

      def doing(&block) block; end

      def calling(&block) block; end
    end
  end
end

Spec::Runner.configure do |config|
  config.include Rango::Test::Helper
  config.include Rango::Test::RspecMatchers
  config.include Rango::Test::RequestHelper
  config.include Webrat::Matchers
  config.include Webrat::HaveTagMatcher

  def with_level(level)
    Rango.logger = Rango::Logger.new(StringIO.new, level)
    yield
    Rango.logger
  end
end
