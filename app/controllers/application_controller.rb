class ApplicationController < ActionController::Base
  include Kakule
  protect_from_forgery
end
