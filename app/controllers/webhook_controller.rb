class WebhookController < ApplicationController
  protect_from_forgery with: :null_session

  EVENT_TYPE_MESSAGE = 'message'

  def callback
    logger.info(params)

    res = reply(params)

    logger.info(res.body) if res.present?
    render :nothing => true, status: :ok
  end

  private
  def reply(params)
    response_service = response_service(params)
    response_text, reply_token  = response_service.form_response

    line_client.reply(reply_token, response_text)  if response_text.present?
  end

  def line_client
    @line_client ||= LineClient.new
  end
end