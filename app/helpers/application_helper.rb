module ApplicationHelper
  def authed?(token = session[:token])
    !Session.each.find { |s| s.token.to_s == token }.nil?
  end
end
