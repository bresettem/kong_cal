class ApplicationController < ActionController::Base
  def after_sign_in_path_for(user)
    user_tribe_items_path(user)
  end
end