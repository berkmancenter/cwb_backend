class AccountsController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  before_action :account_manager?, only: [:create]
  respond_to :json

  def index
    render json: CWB::Account.all
  end

  def create
    @account = CWB::Account.new(account_params)
    @account.build_profile(name: '', email: '')
    if @account.save
      render json: { success: 'Registration Successful.' }
    else
      render json: { error: 'Registration Unsuccessful.' }
    end
  end

  def destroy
    if @current_user.account_manager
      account = CWB::Account.find(params[:id])
      account.destroy
      render json: 'Deletion of account successful'
    else
      render json: 'Deletion of account unsuccessful', status: :unauthorized
    end
  end

  private

  def account_params
    params.require(:account).permit(:username, :password, :account_manager)
  end
end
