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
end