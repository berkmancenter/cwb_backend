class SessionsController < ApplicationController
  respond_to :json

  def sign_in 
    account = CWB::Session.authenticate(session_params[:name], session_params[:password])
    if account 
      render json: { token: account.token }
    else
      render json: { error: 'Login credentials are invalid.' }, status: :unauthorized
    end
  end
  
  def sign_out
    CWB::Session.reset_auth_token(request.headers['HTTP_AUTHORIZATION'])
    redirect_to root_url, :notice => "Logged out!"
  end

  private

  def session_params
    params.require(:session).permit(:id, :name, :password)
  end
end
