class Item < ApplicationRecord

  has_many :item_posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  delongs_to :group
  enum genre: { cosmetics: 0, daily_necessities: 1, groceries: 2, supplement: 3}

end
