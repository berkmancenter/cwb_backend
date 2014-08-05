class AccountsController < ApplicationController
  before_action :authed?
  respond_to :json

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
