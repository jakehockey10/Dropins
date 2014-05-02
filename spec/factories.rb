FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'
    speaking_language TwitterCldr::Shared::Languages.from_code(:en)
    learning_language TwitterCldr::Shared::Languages.from_code(:fr)

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content 'Lorem ipsum'
    user
  end
end