Talent::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { :host => 'convvas.com' }

#  ActionMailer::Base.smtp_settings = {
#    :address  => "smtp.someserver.net",
#    :port  => 25,
#    :user_name  => "someone@someserver.net",
#    :password  => "mypass",
#    :authentication  => :login
#  }
end

