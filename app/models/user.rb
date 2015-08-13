class User < ActiveRecord::Base
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
                    path: ':attachment/:id/:style.:extension',
                    storage: :s3,
                    url: ':s3_domain_url',
                    bucket: Proc.new { |a| a.instance.s3_bucket },
                    s3_protocol: :https,
                    s3_credentials: { access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] },
                    styles: { large: '500x500', medium: '250x250', thumb: '100x100', small: '60' }

  # From http://stackoverflow.com/questions/20533925/why-is-attr-accessor-necessary-in-rails-4:
  # About attr_accessor:
  # "If you declare an `attr_accessor` then you can use it as a `virtual attribute`,
  # which is basically an attribute on the model that isn't persisted to the database."
  attr_accessor :remember_token, :activation_token, :reset_token, :help_token, :dropin_removal_token
  before_save   :downcase_email
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

  # Returns true i the given token matches the digest
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
    user.admin? && ! Relationship.where(followed_id: followed_id, follower_id: follower_id).empty?
  end

  def create_gmail_contact(name, email, user_id, other_user_id, profile_picture)
    GmailContact.create!(name: name,
                         email: email,
                         user_id: user_id,
                         other_user_id: other_user_id,
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

  # get the authorization url for this user.  This url will let the user
  # register or login to WePay to approve our app.

  # returns a url
  def wepay_authorization_url(redirect_uri)
    DropinsApp::Application::WEPAY.oauth2_authorize_url(redirect_uri, self.email, self.name)
  end

  # takes a code returned by wepay oauth2 authorization and makes an api call to generate oauth2 token for this user.
  def request_wepay_access_token(code, redirect_uri)
    response = WEPAY.oauth2_token(code, redirect_uri)
    if response['error']
      raise "Error - #{response['error_description']}"
    elsif !response['access_token']
      raise 'Error requesting access from WePay'
    else
      self.wepay_access_token = response['access_token']
      self.save

      self.create_wepay_account
    end
  end

  def has_wepay_access_token?
    !self.wepay_access_token.nil?
  end

  # makes an api call to WePay to check if current access token for user is still valid
  def has_valid_wepay_access_token?
    return false if self.wepay_access_token.nil?
    response = WEPAY.call('/user', self.wepay_access_token)
    (response && response['user_id']) ? true : false
  end

  def has_wepay_account?
    self.wepay_account_id != 0 && !self.wepay_account_id.nil?
  end

  # creates a WePay account for this user with the user's name
  def create_wepay_account
    if self.has_wepay_access_token? && !self.has_wepay_account?
      params = { name: self.name, description: 'dropin payment' }
      response = WEPAY.call('/account/create', self.wepay_access_token, params)

      if response['account_id']
        self.wepay_account_id = response['account_id']
        return self.save
      else
        raise "Error - #{response['error_description']}"
      end
    end
    raise 'Error - cannot create WePay account'
  end

  def wepay_call(api_call, params)
    response = WEPAY.call(api_call, self.wepay_access_token, params)
    unless response.is_a?(Array)
      if !response
        raise 'Error - no response from WePay'
      elsif response['error']
        respond_to_wepay_response(response)
      end
    end
    response
  end

  def respond_to_wepay_response(response)
    if response['error_code'] === 1006

    else
      raise "Error - #{response['error_description']}"
    end
  end

  # creates a checkout object using WePay API for this user
  def create_checkout(redirect_uri, dropin_amount)
    app_fee = 0
    params = {
      account_id: self.wepay_account_id,
      short_description: 'Dropin paid for',
      type: :EVENT,
      amount: dropin_amount,
      app_fee: app_fee,
      fee_payer: :payee,
      mode: :iframe,
      redirect_uri: redirect_uri
    }
    wepay_call('/checkout/create', params)
  end

  def make_withdrawal(redirect_uri, description = nil)
    params = {
      account_id: self.wepay_account_id,
      redirect_uri: redirect_uri,
      fallback_uri: redirect_uri,
      note:         description ||= "User: #{self.email}",
      mode:         'iframe'
    }
    wepay_call('/withdrawal/create', params)
  end

  def get_withdrawal(withdrawal_id)
    params = {
      withdrawal_id: withdrawal_id
    }
    wepay_call('/withdrawal', params)
  end

  def get_withdrawals(state)
    params = {
      account_id: self.wepay_account_id,
      state: state
    }
    wepay_call('/withdrawal/find', params)
  end

  def get_withdrawal_counts
    account_id = self.wepay_account_id
    # TODO: use wepay batch call for this
    counts = {
      new:      wepay_call('/withdrawal/find', { account_id: account_id, state: 'new' }).count,
      started:  wepay_call('/withdrawal/find', { account_id: account_id, state: 'started' }).count,
      captured: wepay_call('/withdrawal/find', { account_id: account_id, state: 'captured' }).count,
      expired:  wepay_call('/withdrawal/find', { account_id: account_id, state: 'expired' }).count,
      failed:   wepay_call('/withdrawal/find', { account_id: account_id, state: 'failed' }).count
    }
    counts
  end

  def get_wepay_account
    params = {
      account_id: self.wepay_account_id
    }
    wepay_call('/account', params)
  end

  def get_update_uri(redirect_uri)
    params = {
      account_id: self.wepay_account_id,
      mode: :iframe,
      redirect_uri: redirect_uri
    }
    wepay_call('/account/get_update_uri', params)
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

  private

    # Converts email to all lower-case
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
