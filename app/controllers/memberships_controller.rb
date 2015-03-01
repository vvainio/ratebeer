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
      redirect_to @membership.beer_club, notice: 'Your application to join the club has been sent for approval!'
    else
      @beer_clubs = BeerClub.all
      render :new
    end
  end

  def confirm
    beer_club_id = params[:beer_club_id]
    membership_of_current_user = Membership.find_by(user_id: current_user,
                                                    beer_club_id: beer_club_id,
                                                    confirmed: true)

    membership = Membership.find_by(user_id: params[:user_id],
                                    beer_club_id: params[:beer_club_id])

    membership.confirmed = true
    if membership.save && membership_of_current_user.user == current_user
      redirect_to :back, notice: "Membership of #{membership.user.username} confirmed!"
    else
      redirect_to :back
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
