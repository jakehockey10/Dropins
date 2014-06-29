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
  has_many :commitments,
           # foreign_key: 'dropin_id',
           class_name: 'Commitment',
           dependent: :destroy
  has_many :followers,
           through: :reverse_relationships
  has_many :followed_users,
           through: :relationships,
           source: :followed
  has_many :attendances
  has_many :dropins, through: :attendances

  STATES = {
      inactive: 0,
      active: 1
  }

  before_save { email.downcase! || email }
  before_create :create_remember_token
  before_create :create_reset_token
  validates :first_name,
            presence: true,
            length: { maximum: 20 }
  validates :second_name,
            presence: true,
            length: { maximum: 30 }
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

  def commit_to!(dropin)
    commitments.create!(user_id: self.id, dropin_id: dropin.id)
  end

  # are we going to accept refunds?
  # def uncommit_to!(dropin)
  #   commitments.find_by(dropin_id: dropin.id).destroy
  # end

  def show_pay_for_dropin_button(dropin)
    self.has_wepay_account? && dropin.user.has_wepay_account? && self.has_not_paid(dropin)
  end

  def has_not_paid(dropin)
    Commitment.where(user_id: self.id, dropin_id: dropin.id).blank?
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

  def send_password_reset
    create_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def name
    "#{first_name} #{second_name}"
  end

  # get the authorization url for this user.  THis url will let the user
  # register or login to WePay to approve our app.

  # returns a url
  def wepay_authorization_url(redirect_uri)
    WEPAY.oauth2_authorize_url(redirect_uri, self.email, self.name)
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
    if self.wepay_access_token.nil?
      return false
    end
    response = WEPAY.call('/user', self.wepay_access_token)
    response && response['user_id'] ? true : false
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

  # creates a checkout object using WePay API for this user
  def create_checkout(redirect_uri, dropin_amount)
    app_fee = 0

    params = {
      account_id: self.wepay_account_id,
      short_description: 'Dropin paid for',
      type: :EVENT,
      amount: dropin_amount,
      app_fee: app_fee,
      fee_payer: :payer,
      mode: :iframe,
      redirect_uri: redirect_uri
    }
    response = WEPAY.call('/checkout/create', self.wepay_access_token, params)

    if !response
      raise 'Error - no response from WePay'
    elsif response['error']
      raise "Error - #{response['error_description']}"
    end

    return response
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
