class MembershipsController < ApplicationController
  def index
    @memberships = Membership.all
  end

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user_id = current_user.id

    if @membership.save
      current_user.memberships << @membership
      redirect_to user_path current_user
    else
      @beer_clubs = BeerClub.all
      render :new
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.delete if membership.user == current_user
    redirect_to :back
  end
end
