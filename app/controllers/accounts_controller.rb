class AccountsController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  before_action :account_manager?, only: [:create]
  respond_to :json

  def index
    resource = CWB::Account.all
    .map { |a|
      aj = a.as_json
      aj['name'] = a.profile.name
      aj['email'] = a.profile.email
      aj.delete("password_hash")
      aj.delete("token")
      aj
    }

    render json: resource
  end

  def create
    @account = CWB::Account.new(account_params)
    @account.build_profile(profile_params)
    if @account.save
      render json: { success: 'Account Creation Successful.' }, status: 200
    else
      render json: { error: 'Account Creation Unsuccessful.' }, status: 400
    end
  end

  def update
    if account = CWB::Account.find(params[:id])
      if profile = CWB::Profile.find(account.profile)
        profile.update_attributes(profile_params)
        account.update_attributes(account_params)

        if profile.valid? & account.valid?
          profile.save
          account.save
          render json: { success: 'Successfully updated account' }, status: 200
        else
          render json: { error: 'Unable to update account.' }, status: 400
        end
      else
        render json: { error: 'You are not authorized to update this account'}, status: 401
      end
    else
      render json: { error: 'You are not authorized to update this account'}, status: 401
    end
  end

  def destroy
    if @current_user.account_manager
      account = CWB::Account.find(params[:id])
      if account.destroy
        render json: { success: 'Deletion of account successful' }, status: 200
      else
        render json: { error: 'Deletion of account unsuccessful' }, status: 400
      end
    else
      render json: { error: 'Deletion of account unsuccessful' }, status: 401
    end
  end

  private

  def account_params
    params.require(:account).permit(:username, :password, :account_manager)
  end

  def profile_params
    params.require(:account).permit(:name, :email)
  end
end
