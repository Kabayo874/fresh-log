class Item < ApplicationRecord

  has_one_attached :image
  has_many :item_posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :group, optional: true
  enum category: { cosmetics: 0, daily_necessities: 1, groceries: 2, supplement: 3}

end
