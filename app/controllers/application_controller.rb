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

  def account_manager?
    unless @current_user.account_manager
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end
end
