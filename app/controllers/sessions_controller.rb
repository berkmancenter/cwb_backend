class SessionsController < ApplicationController
  respond_to :json

  def create
    account = CWB::Session.authenticate(
      session_params[:username], session_params[:password]
    )
    
    response = 
      if account
        session[:token] = account.token
        { success: 'Login is successful!', status: :success }
      else
        { error: 'Login credentials are invalid.', status: :unauthorized }
      end

    render json: response 
  end

  def destroy
    CWB::Session.reset_auth_token(session[:token])
    session.clear
    redirect_to root_url, notice: 'Logged out!'
  end

  def auth
    render json: {
            authenticated: !!session[:token],
            token: session[:token] || false
          }
  end


  private

  def session_params
    params.require(:session).permit(:id, :username, :password)
  end
end
