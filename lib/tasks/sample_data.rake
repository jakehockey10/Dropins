namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
  task make_jake: :environment do
    make_jake_admin
  end
  task follow_jake: :environment do
    follow_jake
  end
  task jake_follow: :environment do
    jake_follow
  end
  task remove_invalid_relationships: :environment do
    remove_invalid_relationships
  end
end

def make_jake_admin
  User.create!(first_name: 'Jake',
               second_name: 'Smith',
               email: ENV['GMAIL_USERNAME'].dup,
               password: ENV['GMAIL_PASSWORD'],
               password_confirmation: ENV['GMAIL_PASSWORD'],
               state: 1,
               admin: true)
end

def make_users
  99.times do |n|
    first_name = Faker::Name.first_name
    second_name = Faker::Name.last_name
    email = "example-#{n+1}@railstutorial.org"
    password = 'password'
    state = 1
    User.create!(first_name: first_name,
                 second_name: second_name,
                 email: email,
                 state: state,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.limit( 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def follow_jake
  users = User.where.not(email: 'jakehockey10@gmail.com')
  jake = User.find_by(email: 'jakehockey10@gmail.com')
  users.each do |user|
    unless user.followed_users.include? jake
      user.follow!(jake)
    end
  end
end

def jake_follow
  users = User.where.not(email: 'jakehockey10@gmail.com')
  jake = User.find_by(email: 'jakehockey10@gmail.com')
  users.each do |user|
    unless jake.followed_users.include? user
      jake.follow!(user)
    end
  end
end

def remove_invalid_relationships
  bad_relationships = Relationship.where('follower_id = followed_id')
  bad_relationships.each do |r|
    r.destroy!
  end
end