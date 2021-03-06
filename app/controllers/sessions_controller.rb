class SessionsController < ApplicationController
  respond_to :json

  def create
    account = CWB::Session.authenticate(
      session_params[:username], session_params[:password]
    )

    if account
      session[:token] = account.token
      response = {
              authenticated: !!session[:token],
              token: session[:token] || false,
              id: account.id,
              username: account.username,
              name: account.name,
              email: account.email,
              isAdmin: !!account.account_manager
            }
      status_code = 200
    else
      response = { error: 'Login credentials are invalid.', status: :unauthorized }
      status_code = 401
    end

    render json: response, status: status_code 
  end

  def destroy
    CWB::Session.reset_auth_token(session[:token])
    session.clear
    redirect_to root_url, notice: 'Logged out!'
  end

  def auth
    if account = CWB::Account.find_by_token(session[:token])
      render json: {
              authenticated: !!session[:token],
              token: session[:token] || nil,
              id: account.id,
              username: account.username,
              name: account.name,
              email: account.email,
              isAdmin: !!account.account_manager
            }
    else
      render json: {
              authenticated: !!session[:token],
              token: session[:token] || nil
            }
    end
  end


  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
