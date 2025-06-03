class Item < ApplicationRecord

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }
  validates :category, presence: true
  validates :image, presence: true   

  has_many :item_posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :group, optional: true
  enum category: { cosmetics: 0, daily_necessities: 1, groceries: 2, supplement: 3}
  enum status: { unopened: 0, start: 1, active: 2, finish: 3, discard: 4, repeat: 5 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end



end
