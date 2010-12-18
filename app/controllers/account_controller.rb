class AccountController < ApplicationController
  resource_controller :singleton

  def update
    if object.update_attributes params[:user]
      redirect_to account_url
    else
      render :edit
    end
  end

  private

  def object
    @object ||= current_user
  end

end