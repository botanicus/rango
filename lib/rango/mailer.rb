# encoding: utf-8

# mail("rango@project.org", "joe@doe.com", "Free VIAGRA") do
#   render "mails/spam.html"
# end
begin
  require "mail"
rescue LoadError
  raise "You have to install mail gem!"
end

module Rango
  module Mailing
    def mail(to, from, subject, &block)
      Mail.deliver do |mail|
        mail.to = to
        mail.from = from
        mail.subject = subject
        mail.body = block.call
        puts self
      end
    rescue Errno::ECONNREFUSED
      Rango.logger.error("E-mail from #{caller[0]} can't be send due to refused connection to the SMTP server")
    end
  end
end

Rango::Controller.send(:include, Rango::Mailing)
