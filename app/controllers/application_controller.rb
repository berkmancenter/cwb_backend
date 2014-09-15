class ApplicationController < ActionController::Base
  respond_to :json
  
  def authed?
    
    unless @current_user
      render json: { error: 'You must be logged in.' }, status: :unauthorized 
    end
  end

  def set_current_user
    @current_user ||= session[:token] && CWB::Account.find_by(token: session[:token])
  end
end
