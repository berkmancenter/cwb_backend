class AccountsController < ApplicationController
  def index
    render json: CWB::Account.each
  end
end
