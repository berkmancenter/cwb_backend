module Requests
  def json
    @json ||= JSON.parse(response.body)
  end

  def sign_in(account)
    post '/sessions', session: { username: account.username, password: account.password }
  end
end
