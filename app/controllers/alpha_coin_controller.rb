class AlphaCoinController < ApplicationController
  def update_alpha_coin
    AlphaCoin.update_coin
    respond_to do |format|
      format.html { redirect_to root_path, notice: "AlphaCoin was successfully updated." }
    end
  end
end