FactoryGirl.define do
  factory :user do
    sequence(:first_name) { 'Person' }
    sequence(:second_name) { |n| "#{n}"}
    sequence(:email) { |n| "Person_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content 'Lorem ipsum'
    user
  end

  factory :dropin do
    sequence(:date) { Time.now }
    sequence(:price) { 15 }
    sequence(:rink) { Rink.new }
    sequence(:limit) { 20 }
  end

  factory :attendance do
    dropin
    user
    paid false
  end
end