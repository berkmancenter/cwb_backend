require 'bcrypt'

module CWB
  class Account < ActiveRecord::Base
    include BCrypt
    attr_accessor :password, :name, :email
    validates_presence_of :username, :password, on: :create
    before_save :encrypt_password
    before_create :set_auth_token
    has_one :profile, dependent: :destroy
    after_initialize :set

    def set
      if self.profile
        self.name = self.profile.name
        self.email = self.profile.email
      end
    end

    # def to_json
    #   data = super
    #   data[:name] = self.profile.name
    # end
    # def username=(new_name)
    #   new_name = self.profile.name
    #   write_attribute(:name, new_name)
    # end 

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
