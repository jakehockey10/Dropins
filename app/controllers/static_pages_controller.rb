class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      # Consider showing previous dropins!
      @dropins = Dropin.where('date >= ?', Time.zone.now).order('date asc').paginate(page: params[:page])
      # Consider showing only rinks in the immediate region
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
