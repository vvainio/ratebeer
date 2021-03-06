module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # Rails ActiveRecord solution
    return nil if ratings.empty?
    ratings.average(:score).round(1)

    # Ruby solution using map & inject
    # a = ratings.map(&:score)
    # (a.inject(0.0) { |sum, score| sum + score }.to_f / a.size).round(1)

    # Shorthands for inject / reduce
    # (a.inject(:+).to_f / a.size).round(1)
    # (a.reduce(:+).to_f / a.size).round(1)
  end
end
