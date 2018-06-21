class Dropin < ActiveRecord::Base
  has_many :attendances, dependent: :destroy
  has_many :skaters, through: :attendances, source: :user
  belongs_to :rink
  belongs_to :user

  acts_as_notifiable :users,
                     targets: ->(_dropin, _key) {User.all.to_a},
                     tracked: true
  acts_as_messageable
  groupify :group_member

  validates :date,
            presence: true,
            date:     { after:  proc {Time.now - 1.minute},
                        before: proc {Time.now + 1.year} },
            on:       :create

  validates :price,
            presence:     true,
            numericality: { greater_than: 0 }
  validates :rink,
            presence: true
  validates :limit,
            presence:     true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :description,
            presence: true,
            length:   { maximum: 140, minimum: 10 }

  def not_full?
    limit > skaters.count
  end

  def full?
    limit <= skaters.count
  end

  def user_is_not_attending(user_id)
    attendances.count.zero? || attendances.find_by(user_id: user_id).nil?
  end

  def user_is_attending(user_id)
    attendances.count.positive? && attendances.find_by(user_id: user_id)
  end

  def user_paid(user)
    if user
      attendance = attendances.find_by(user_id: user.id)
      attendance&.paid
    else
      false
    end
  end

  def name
    # "Dropin #{id}"
    description
  end

  def mailboxer_email(_object)
    nil
  end

  def show_register_link?(user)
    in_the_future? unless skaters.include?(user)
  end

  def in_the_future?
    date > Time.zone.now
  end

  def followers_attending(user)
    followers_going = skaters.where(id: user.following).map(&:name)
    if followers_going.count == 1
      "#{followers_going.to_sentence} is going."
    else
      "#{followers_going.to_sentence} are going."
    end
  end

  def skater_context(user)
    if self.user == user
      'You created this dropin!'
    elsif skaters.include? user
      in_the_future? ? 'You are skating in this dropin!' : 'You skated in this dropin!'
    else
      in_the_future? ? 'You can sign up to this dropin!' : 'You missed out!'
    end
  end

end
