class Item < ApplicationRecord

  has_many :item_posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :user
  delongs_to :group

end
