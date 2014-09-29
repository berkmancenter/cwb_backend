class UserMailer < ActionMailer::Base
  default from: "dan@metabahn.com"

  def init_completion_email(email)
    mail(to: email, subject: 'Your project has been created successfully.')
  end
end
