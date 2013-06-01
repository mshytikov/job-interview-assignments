class TransfersController < ApplicationController

  before_filter :find_user

  def create
    transfer = current_user.build_transfer(@to_user, params[:amount])
    if transfer.save
      flash.now[:alert] = "Successfully transfered #{amount} to User ID: #{to_user_id}"
    else
      flash.now[:error] = transfer.base_error
    end
    redirect_to root
  end


  private
  def find_user
    @to_user = User.find_by_id(params[:to_user_id]) 
    if @to_user.nil?
      flash.now[:error] = "Unknown user with id =#{params[:to_user_id]}"
      redirect_to root
    end
  end 
end

