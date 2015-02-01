class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates_uniqueness_of :user_id,
                          scope: :beer_club_id,
                          message: 'is already a member of this club'
end
