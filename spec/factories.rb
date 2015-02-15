FactoryGirl.define do
  factory :user do
    username 'test_user'
    password 'Passw0rd'
    password_confirmation 'Passw0rd'
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name 'anonymous'
    year 1900
  end

  factory :beer do
    name 'anonymous'
    brewery
    style
  end

  factory :style do
    name 'Lager'
    description 'Lager is a style'
  end
end
