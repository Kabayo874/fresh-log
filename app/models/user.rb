class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, presence: true

  enum status: { active: 0, deactivated: 1, withdrawn: 2 }
  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :account_deactivated
  end
  

  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :items, dependent: :destroy
  has_many :item_posts, dependent: :destroy
  # has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy


  has_one_attached :profile_image
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def member_of?(group)
    group.group_members.exists?(user_id: self.id)
  end

  before_update :handle_withdrawal, if: :will_be_withdrawn?

  private

  def will_be_withdrawn?
    status_changed? && withdrawn?
  end

  def handle_withdrawal
    group_members.update_all(status: false)
  end

end
