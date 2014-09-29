class UserMailer < ActionMailer::Base
  default from: "dan@metabahn.com"

  def init_completion_email(email, success)
    if email
      if success
        mail(to: email, subject: 'Your project has been created successfully.')
      else
        mail(to: email, subject: 'Your project creation failed.')
      end
    end
  end
end
