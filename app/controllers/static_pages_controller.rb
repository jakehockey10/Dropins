class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @micropost = current_user.microposts.build if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
      @dropins = Dropin.all.paginate(page: params[:page], order: 'date asc')
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
