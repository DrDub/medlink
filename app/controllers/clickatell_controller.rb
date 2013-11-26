# Ref: http://lukeredpath.co.uk/blog/sending-sms-messages-from-your-rails-application.html

require 'clickatell'

class ClickatellController  < ApplicationController

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
      data  = SMS.parse params
      order = Order.create_from_text data
      order.confirmation_message
    rescue SMS::ParseError => e
      I18n.t 'order.unparseable'
    rescue => e
      Rails.logger.info "Error in `create_order`: #{e.message}"
      SMS.friendly e.message
    end
    SMS.new(params[:From], response).deliver
  end

  #TODO: (#164): Merge Clickatell's create and Twilio's create_order.
  def create # Clickatell
    response = begin
      sms = SMS.new(CLICKATELL_CONFIG)
      sms.create(params[:recipient], params[:message_text])
      flash[:notice] = "Message sent succesfully!"
      redirect_to :back
    rescue Clickatell::API::Error => e
      flash[:error] = "Clickatell API error: #{e.message}"
      redirect_to :back
    end
  end

end
