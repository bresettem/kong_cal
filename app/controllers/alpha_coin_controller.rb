class AlphaCoinController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  include Shared

  def update_alpha_coin
    update_shared_alpha_coin
    respond_to do |format|
      format.html { redirect_to user_tribe_items_path(@user), notice: "AlphaCoin was successfully updated." }
    end
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end
end