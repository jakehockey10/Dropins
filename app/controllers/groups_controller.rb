class GroupsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :create, :edit, :update, :destroy]

  def index
  end

  def show
    @group = Group.find(params[:id])
    redirect_to root_url and return unless current_user.activated?
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.add(current_user, as: 'manager')
    if @group.save
      # @group.send_something???
      flash[:success] = 'Your group has been created!'
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def group_params
      params.require(:group).permit(:name)
    end
end
