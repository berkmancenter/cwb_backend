module CWB
  class Session < CWB::Resource
    def self.authenticate(name, password)
      if account = CWB::Account.find_by_name(name)
        account if BCrypt::Password.new(account.password_hash) == password
      end
    end

    def self.reset_auth_token(session_token)
      if account = CWB::Account.find_by_token(session_token)
        begin
          new_token = SecureRandom.hex
        end while CWB::Account.exists?(token: new_token)
        account.update_attribute(:token, new_token)
      end
    end

  end
end
