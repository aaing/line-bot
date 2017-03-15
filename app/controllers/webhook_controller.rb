require_relative '../../config/initializers/constants'

class WebhookController < ApplicationController
  protect_from_forgery with: :null_session

  EVENT_TYPE_MESSAGE = 'message'

  def callback
    logger.info(params)

    res = reply(params)

    logger.info(res.body) if res.present?
    render :nothing => true, status: :ok
  end

  
  def reply(params)

    event = params["events"][0]
    event_type = event["type"]
    input_text = (event["message"]["text"] if event_type == Constants::EVENT_TYPE_MESSAGE) || ''
    reply_token = event["replyToken"]
    response_text = input_text


    # response_service = response_service(params)
    # response_text, reply_token  = response_service.form_response

    line_client.reply(reply_token, response_text)  if response_text.present?
  end

  def response_service(input_text)
    ResponseService.new(input_text)
  end

  def line_client
    @line_client ||= LineClient.new
  end
end