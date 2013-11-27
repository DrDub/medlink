class SMSJob < BaseJob
  include SuckerPunch::Job

  def twilio_perform number, message
    SMS.new(number, message).twilio_deliver
  end

  def clickatell_perform number, message
#FIXME (#164)
#    SMS.new(number, message).clickatell_deliver
  end
end
