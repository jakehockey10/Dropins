class User < ActiveRecord::Base
  include Merchantable

  acts_as_messageable
  groupify :group_member
  groupify :named_group_member

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :attendances
  has_many :dropins, through: :attendances
  has_many :gmail_contacts
  has_attached_file :avatar,
                    path:           ':attachment/:id/:style.:extension',
                    storage:        :s3,
                    url:            ':s3_domain_url',
                    bucket:         Proc.new { |a| a.instance.s3_bucket },
                    s3_protocol:    :https,
                    s3_credentials: { access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] },
                    styles:         { large: '500x500', medium: '250x250', thumb: '100x100', small: '60' }

  # From http://stackoverflow.com/questions/20533925/why-is-attr-accessor-necessary-in-rails-4:
  # About attr_accessor:
  # "If you declare an `attr_accessor` then you can use it as a `virtual attribute`,
  # which is basically an attribute on the model that isn't persisted to the database."
  attr_accessor :remember_token, :activation_token, :reset_token, :help_token, :dropin_removal_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :second_name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # has_secure_password enforces presence validations upon object creation.
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password

  validates_attachment :avatar, content_type: { content_type: %w(image/jpeg image/gif image/png) }
  validates_attachment_content_type :avatar, content_type: /\Aimage/
  validates_attachment_file_name :avatar, matches: [/png\Z/, /jpe?g\Z/]

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sets the help attributes.
  def create_help_request_digest
    self.help_token = User.new_token
    update_columns(help_digest: User.digest(help_token), help_sent_at: Time.zone.now)
  end

  # Sets the dropin removal request attributes
  def create_dropin_removal_digest
    self.dropin_removal_token = User.new_token
    update_columns(dropin_removal_digest: User.digest(dropin_removal_token), dropin_removal_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Sends help email.
  def send_help_request_email(message)
    UserMailer.help_request(self, message).deliver_now
  end

  # Sends email to dropin creator.
  def send_email_to_dropin_creator(dropin, message)
    UserMailer.dropin_creator_email(dropin, self, message).deliver_now
  end

  # Sends dropin removal request.
  def send_dropin_removal_request(dropin, message)
    UserMailer.dropin_removal_request(dropin, self, message).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  def feed
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def create_gmail_contact?(user, followed_id, follower_id)
    user.admin? && !Relationship.where(followed_id: followed_id, follower_id: follower_id).empty?
  end

  def create_gmail_contact(name, email, user_id, other_user_id, profile_picture)
    GmailContact.create!(name:            name,
                         email:           email,
                         user_id:         user_id,
                         other_user_id:   other_user_id,
                         profile_picture: profile_picture)
  end

  def attending_dropin?(dropin)
    attendances.find_by(dropin_id: dropin.id)
  end

  def join_dropin!(dropin)
    attendances.create!(dropin_id: dropin.id)
  end

  def leave_dropin!(dropin)
    attendances.find_by(dropin_id: dropin.id).destroy
  end

  def name
    "#{first_name.titleize} #{second_name.titleize}"
  end

  def s3_bucket
    if Rails.env.development?
      ENV['S3_BUCKET_NAME_DEVELOPMENT']
    else
      ENV['S3_BUCKET_NAME_PRODUCTION']
    end
  end

  def mailboxer_email(object)
    nil
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  private

    # Converts email to all lower-case
    def downcase_email
      self.email = email.downcase
    end

end
