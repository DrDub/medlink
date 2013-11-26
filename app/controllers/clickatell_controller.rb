# Ref: http://lukeredpath.co.uk/blog/sending-sms-messages-from-your-rails-application.html

require 'clickatell'

class ClickatellController

  def initialize(config)
    @config = config
  end
  
  def create(recipient, message_text)
    api.send_message(recipient, message_text)
  end

  def receive
    Rails.logger.info( "Received SMS: #{params}" )

    case params[:Body]
    when /list/i
      list
    else
      create_order
    end

    head :no_content
  end

private

  def list
    raise "Not Implemented"
  end

  def create_order
    response = begin
      sms = SMS.new(CLICKATELL_CONFIG)
#      sms.create(params[:recipient], params[:message_text])
      data  = SMS.parse params
#      flash[:notice] = "Message sent succesfully!"
      order = Order.create_from_text data
      order.confirmation_message
      redirect_to :back
    rescue Clickatell::API::Error => e
      flash[:error] = "Clickatell API error: #{e.message}"
      redirect_to :back
    rescue SMS::ParseError => e
      I18n.t 'order.unparseable'
    rescue => e
      Rails.logger.info "Error in `create_order`: #{e.message}"
      SMS.friendly e.message
    end
    SMS.new(params[:From], response).deliver
  end
  
  def api
    @api ||= Clickatell::API.authenticate(
      @config[:api_key],
      @config[:username],
      @config[:password]
    )
  end
end
