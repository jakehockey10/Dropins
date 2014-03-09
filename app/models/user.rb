class User < ActiveRecord::Base
  has_many :microposts,
           dependent: :destroy
  has_many :relationships,
           foreign_key: 'follower_id',
           dependent: :destroy
  has_many :reverse_relationships,
           foreign_key: 'followed_id',
           class_name: 'Relationship',
           dependent: :destroy
  has_many :followers,
           through: :reverse_relationships
  has_many :followed_users,
           through: :relationships,
           source: :followed

  LANGUAGES = TwitterCldr::Shared::Languages.all.values

  STATES = {
      inactive: 0,
      active: 1
  }

  before_save { email.downcase! }
  before_create :create_remember_token
  before_create :create_reset_token
  validates :name,
            presence: true,
            length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password,
            length: { minimum: 6 },
            #if: :validate_password?
            if: :password_required?
  validates :password_confirmation,
            presence: true,
            #if: :validate_password?
            if: :password_required?
  validates :speaking_language,
            presence: true,
            inclusion: { in: LANGUAGES }
  validates :learning_language,
            presence: true,
            inclusion: { in: LANGUAGES }

  state_machine :state, initial: :inactive do
    STATES.each do |name, value|
      state name, value: value
    end

    event :activate do
      transition all => :active
    end

    event :deactivate do
      transition all => :inactive
    end
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def send_password_reset
    create_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private

    def create_remember_token
      self.remember_token = User.create_token
    end

    def create_reset_token
      self.password_reset_token = User.create_token
    end

    def create_email_token
      self.email_token = User.create_token
    end

    def User.create_token
      User.encrypt(User.new_token)
    end

    def validate_password?
      password.present? || password_confirmation.present?
    end

    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end
end
