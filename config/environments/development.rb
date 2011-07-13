Kakule::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  require 'hirb'
  Hirb.enable
  
  EVENTFUL_APPLICATION_KEY = "2gvs63mL8FnKFXL3"
  SIMPLEGEO_OAUTH_KEY = "aQTVSUHfyWD7NeyqmSwFRaQxbEF8TUbP"
  SIMPLEGEO_SECRET = "VNYHLGpJTR6v4Lm52xkTv9ybny3JkKt2"
  
  HOTELS_COMBINED_API_KEY = "F7538EB2-2B63-4AE1-8C43-2FAD2D83EACB"
  HOTELS_COMBINED_USER_ID = "31115"
  
  EXPEDIA_AIR_API_KEY   = "bj5gt59kj7n3jue88q97v9b3"
  EXPEDIA_CAR_API_KEY   = "hgskw36r4jbcgknm9mj56ejf"
  EXPEDIA_HOTEL_API_KEY = "cfhk5quqg46dxr3am35kd39b"
  EXPEDIA_CID = "55505"
  
  SimpleGeo::Client.set_credentials(SIMPLEGEO_OAUTH_KEY, SIMPLEGEO_SECRET)
end

