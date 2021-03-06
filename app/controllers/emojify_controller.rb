class EmojifyController < ApplicationController
  before_action :validate_token!, only: [:create]

  def create
    render json: response_json
  end

  def show
    converter = EmojiConverter.new(params[:image_url])
    send_data converter.data, type: converter.content_type, disposition: 'inline'
  end

  private

  def slack_params
    params.permit(:token, :team_id, :team_domain, :channel_id, :channel_name, :user_id, :user_name, :command, :text)
  end

  def validate_token!
    render status: :unauthorized unless slack_params[:token] == ENV['EMOJIFY_SLACK_TOKEN']
  end

  def response_json
    {
      text: response_text,
      attachments: [
        {
          image_url: emojify_url(image_url: params[:text])
        }
      ]
    }
  end

  def response_text
    "Save the image below to your desktop. Navigate to https://betterment.slack.com/customize/emoji and upload the image."
  end
end
