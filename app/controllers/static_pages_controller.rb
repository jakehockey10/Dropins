class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @micropost = current_user.microposts.build if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
      @dropins = Dropin.order('date asc').paginate(page: params[:page])
      @rinks = Rink.all
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
