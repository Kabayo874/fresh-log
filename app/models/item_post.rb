class ItemPost < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  belongs_to :item

  validates :review, presence: true, length: { maximum: 500 }
  validates :image, presence: true 

  

end
