require 'net/smtp'

class NotifierWorker
  include Sidekiq::Worker

  def perform(msg)
    message = <<MESSAGE_END
    From: Broken Link Checker <brokenlinks@downloadrare.com>
    To: Downloadrare Admin <admin@downloadrare.com>
    Subject: Found Broken Links

    #{msg}
    MESSAGE_END

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message message, 'brokenlinks@downloadrare.com','admin@downloadrare.com'
    end
  end
end