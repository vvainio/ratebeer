class MembershipsController < ApplicationController
  before_action :ensure_that_signed_in

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user_id = current_user.id

    if @membership.save
      current_user.memberships << @membership
      redirect_to @membership.beer_club, notice: "Welcome to the club, #{current_user.username}!"
    else
      @beer_clubs = BeerClub.all
      render :new
    end
  end

  def destroy
    beer_club = BeerClub.where(id: params[:membership][:beer_club_id]).first
    membership = Membership.where(
        beer_club_id: beer_club,
        user_id: current_user).first

    membership.delete if membership.user == current_user
    redirect_to current_user, notice: "Successfully ended membership in #{beer_club.name}."
  end
end
