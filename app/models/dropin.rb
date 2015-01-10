class Dropin < ActiveRecord::Base
  acts_as_messageable

  has_many :attendances
  has_many :skaters, through: :attendances, source: :user
  belongs_to :rink
  belongs_to :user

  validates :date,
            presence: true,
            date: { after:  Proc.new { Time.now - 1.minute },
                    before: Proc.new { Time.now + 1.year } }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :rink,  presence: true
  validates :limit, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def is_not_full
    self.limit > self.skaters.count
  end

  def is_full
    self.limit <= self.skaters.count
  end

  def user_is_not_attending(user_id)
    attendances.count === 0 || attendances.find_by(user_id: user_id).nil?
  end

  def user_is_attending(user_id)
    attendances.count > 0 && attendances.find_by(user_id: user_id)
  end

  def name
    "Dropin #{id}"
  end

  def mailboxer_email(object)
    nil
  end

  def show_register_link?(user)
    unless skaters.include?(user)
      is_in_the_future?
    end
  end

  def is_in_the_future?
    self.date > Time.zone.now
  end

  def followers_attending(user)
    followers_going = self.skaters.where(id: user.followed_users).map { |u| u.name }
    if followers_going.count == 1
      "#{followers_going.to_sentence} is going."
    else
      "#{followers_going.to_sentence} are going."
    end
  end

end
