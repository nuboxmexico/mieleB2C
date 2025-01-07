class ApplicationMailer < ActionMailer::Base
  default from: "Miele Shop <#{Rails.application.secrets.mail_admin}>"
end