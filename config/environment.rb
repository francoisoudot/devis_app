# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

  ActionMailer::Base.smtp_settings = {
  :user_name => 'xxx',
  :password => 'xxx',
  :domain => 'http://devisapp.herokuapp.com/',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true

}
