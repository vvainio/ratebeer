class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validate :uniqueness_of_membership

  def uniqueness_of_membership
    if user.beer_clubs.exists?(beer_club)
      errors.add :base, 'User is already a member of this club'
    end
  end
end
