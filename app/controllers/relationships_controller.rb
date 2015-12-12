class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # Note:
  # "The actions in Listing 12.35 degrade gracefully, which means
  # that they work fine in browsers that have JavaScript disabled
  # (although a small amount of configuration is necessary, as
  # shown in Listing 12.36)."

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    payload = { this: :data }
    ActiveSupport::Notifications.instrument 'follow.user', payload do
      # do your custom stuff here
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end