SHOW_PROJECT_CIRCLE = true
# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_internal = Encoding.find("UTF-8")

# Initialize the rails application
Talent::Application.initialize!


ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => "canvvas.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
