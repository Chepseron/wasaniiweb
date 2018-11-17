unless Rails.env.test? 
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :user_name => 'noreply@wasanii.com',
    :password => 'Mediawasanii78890',
    :domain => "wasaniimedia.com",
    :authentication => :plain,
    :enable_starttls_auto => true,
  }
  ActionMailer::Base.delivery_method = :smtp
end

