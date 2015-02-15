class Style < ActiveRecord::Base
  has_many :beers

  validates :name, presence: true
  validates :description, presence: true

  def to_s
    "#{name}"
  end
end
