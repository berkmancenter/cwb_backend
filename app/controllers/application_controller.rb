class ApplicationController < ActionController::Base
  include ApplicationHelper

  private

  def has_auth_token? 
    authenticate_or_request_with_http_token do |token, options|
      CWB::Account.find_by_token(token).present?
    end
  end
end
