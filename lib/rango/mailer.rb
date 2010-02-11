# encoding: utf-8

require "net/smtp"

# Mailer.new("noreply@rangoproject.org", "RangoProject.org")
#  self.to = "tony@example.com"
#  self.subject = "Just hey"
#  self.body = "Hey Tony, what's up?"
# end
module Rango
  class Mailer
    @@config = {smtp: ["localhost", 25]}

    def self.mail(options = Hash.new)
      self.new(options[:from]).tap do |mailer|
        mailer.body = options[:body]
      end
    end

    attr_accessor :to, :to_alias
    attr_accessor :from, :from_alias
    attr_accessor :body, :subject

    def initialize(from, from_alias = from, &block)
      @from, @from_alias = from, from_alias
      unless block.nil?
        block.instance_eval(&block)
        block.send
      end
    end

    def raw
      <<-EOF
From: #{from_alias} <#{from}>
To: #{to_alias} <#{to}>
Subject: #{subject}

#{body}
      EOF
    end

    def send(to)
      Net::SMTP.start(*@@config[:smtp]) do |smtp|
        smtp.send_message(self.raw, @from, to)
      end
    end
  end
end
