class AccountsController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  before_action :account_manager?, only: [:create]
  respond_to :json

  # def index
  #   resource = CWB::Account.all
  #   # .map { |a| 
  #   #   aj = a.as_json
  #   #   aj['name'] = a.profile.name
  #   #   aj['email'] = a.profile.email
  #   #   aj
  #   # }
  #   render json: resource
  # end

  def create
    @account = CWB::Account.new(account_params)
    @account.build_profile(name: '', email: '')
    if @account.save
      render json: { success: 'Registration Successful.' }
    else
      render json: { error: 'Registration Unsuccessful.' }
    end
  end

  def update
    if account = CWB::Account.find(params[:id])
      if profile = CWB::Profile.find(account.profile)
        profile.update_attributes(profile_params)
        profile.save
      end
      account.update_attributes(account_params)
      account.save
      render json: 'Successfully updated account'
    else 
      render json: 'You are not authorized to update this account', status: :unauthorized
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

  def profile_params
    params.require(:account).permit(:name, :email)
  end
end
