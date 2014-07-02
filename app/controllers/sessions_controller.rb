class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    cwb_session = Session.create
    session[:token] = cwb_session[:token]
    
    render json: cwb_session
  end

  def destroy
    Session.destroy_for_token(params[:token] || session[:token])
    session[:token] = nil

    render nothing: true
  end
end
