class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  #Common error with handling of invalid param value
  class InvalidParameterValue < RuntimeError; end

  rescue_from InvalidParameterValue, :with => :handle_invalid_parameter_value

  private 
  def handle_invalid_parameter_value(error)
    respond_to do |format|
      format.html { render :text => error.message,  :status => :unprocessable_entity }
      format.any(:xml, :json) { render request.format.to_sym => { error: error.message }, :status => :unprocessable_entity }
    end
  end

end
