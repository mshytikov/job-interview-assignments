class TransfersController < ApplicationController
  before_filter :lo
  def create
    transfer = current_user.build_transfer(params[:to_user_id], params[:amount])
    if transfer.save
      flash.now[:alert] = "Successfully transfered #{amount} to User ID: #{to_user_id}"
    else
      flash.now[:error] = transfer.base_error
    end
    redirect_to root

  end


end
