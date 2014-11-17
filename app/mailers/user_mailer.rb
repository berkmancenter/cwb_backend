class UserMailer < ActionMailer::Base
  default from: "notifications@fwb.berkmancenter.org"

  def init_completion_email(email, success, project_name)
    if success
      mail(to: email, subject: "Your project (#{project_name}) has been created successfully.") do |f|
      	f.text {''}
      end
    else
      mail(to: email, subject: "Your project (#{project_name}) creation failed.") do |f|
      	f.text {'Unable to create your project. Please make sure Path is a valid directory.'}
      end
    end
  end
end
