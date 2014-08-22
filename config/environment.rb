# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

  ActionMailer::Base.smtp_settings = {
  # :user_name => 'francois.oudot',
  # :password => 'fro261813',
  # :domain => 'http://whatever.com/',
  # :address => 'smtp.sendgrid.net',
  # :port => 587,
  # :authentication => :plain,
  # :enable_starttls_auto => true
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'baci.lindsaar.net',
  :user_name            => 'momganizer@gmail.com',
  :password             => 'fromomganizer',
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}