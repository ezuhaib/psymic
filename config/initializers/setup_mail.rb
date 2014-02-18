ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = "www.psymic.com"

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.zoho.com",
  :port                 => 465,
  :user_name            => "admin@psymic.com",
  :password             => "pz0i3as5c0zp",
  :ssl                  => true,
  :tls                  => true,
  :authentication       => :login,
  :enable_starttls_auto => true
}