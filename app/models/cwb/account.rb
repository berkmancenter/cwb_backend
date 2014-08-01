require 'bcrypt'

module CWB
  class Account < ActiveRecord::Base
    include BCrypt
    attr_accessor :password
    validates_presence_of :name, :email, :password, on: :create
    before_save :encrypt_password
    before_create :set_auth_token

    private

    def set_auth_token
      return if token.present?

      begin
        self.token = SecureRandom.hex
      end while self.class.exists?(token: token)
    end

    def encrypt_password
      return false unless password.present?
      self.password_hash = BCrypt::Password.create(password)
    end
  end
end
