class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def verify_token
    unless params[:token] == Rails.application.secrets.slack_token
      head 403
    end
  end
end
