class TransfersController < ApplicationController

  before_filter :find_user

  def create
    amount = params[:transfer][:amount]
    transfer = current_user.build_transfer(@to_user, amount)
    if transfer.save
      flash[:notice] = "Successfully transfered #{amount} to User ID: #{@to_user.id}"
    else
      flash[:error] = transfer.errors.full_messages.first
    end
    redirect_to root_url
  end


  private
  def find_user
    @to_user = User.find_by_id(params[:transfer][:to_user_id]) 
    if @to_user.nil?
      flash[:error] = "Invalid destination"
      redirect_to root_url
    end
  end 
end

