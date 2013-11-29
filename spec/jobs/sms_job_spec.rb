require 'spec_helper'
require 'clickatell'

describe SMSJob do
  include SmsSpec::Helpers

  it 'just sends a Twilio text message' do
    subject.twilio_perform '+12345678901', 'Test'
    open_last_text_message_for '+12345678901'
    current_text_message.should have_body 'Test'
  end

  it 'just sends a Clickatell text message' do
    # Got TEST NUMBER FROM: http://forums.clickatell.com/clickatell/
    #    topics/clickatell_sandbox_similar_to_paypal_sandbox
    @to_number   = '27999900001' # TEST NUMBER
    @from_number = '27999900005' # TEST NUMBER
    @api = Clickatell::API.authenticate(
      ENV["CLICKATELL_API_KEY"],
      ENV["CLICKATELL_LOGIN"],
      ENV["CLICKATELL_PASSWORD"]
    )
    additional_opts = { from: @from_number }
    expect { 
      @api.send_message(@to_number, 'Hello from clickatell', additional_opts)
    }.to raise_error("No Credit Left")
  end

end
