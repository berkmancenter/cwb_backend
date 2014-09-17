class ProfilesController < ApplicationController
  before_action :set_current_user
  before_action :authed?
  respond_to :json

  def index
    profiles = CWB::Profile.all
    render json: profiles
  end

  def update
    if @current_user.profile.id == params[:id].to_i
      profile = CWB::Profile.find(params[:id])
      profile.update_attributes(profile_params)
      profile.save
      render json: 'Successfully updated profile'
    else 
      render json: 'You are not authorized to update this profile', status: :unauthorized
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :email)
  end
end
