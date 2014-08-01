class AccountsController < ApplicationController
  respond_to :json
  before_filter :auth_token?

  def index
    render json: CWB::Account.all
  end

  def create
    @account = CWB::Account.new(account_params)
    if @account.save
      render json: { success: 'Registration Successful.' }
    else
      render json: { error: 'Registration Unsuccessful.' }
    end
  end

  private

  def auth_token?
    authenticate_or_request_with_http_token do |token, options|
      CWB::Account.find_by_token(token).present?
    end
  end

  def account_params
    params.require(:account).permit(:id, :name, :email, :password)
  end
end
