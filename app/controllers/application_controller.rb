class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :authenticate_user!

  #Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  protected
  def authenticate_user!
    redirect_to signin_path unless signed_in?
  end
end
