module CWB
  class Session < CWB::Resource
    def self.authenticate(name, password)
      account = CWB::Account.find_by_name(name)
      account if BCrypt::Password.new(account.password_hash) == password
    end

    def self.reset_auth_token(header)
      # trims off the Token token=""
      token = header[13..-2]
      account = CWB::Account.find_by_token(token)
      begin
        account.token = SecureRandom.hex
      end while CWB::Account.exists?(token: account.token)
      account.update(token: account.token)
    end
  end
end
