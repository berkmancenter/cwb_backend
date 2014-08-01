class AccountsController < ApplicationController
  respond_to :json
  before_filter :has_auth_token?

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

  def account_params
    params.require(:account).permit(:id, :name, :email, :password)
  end
end
