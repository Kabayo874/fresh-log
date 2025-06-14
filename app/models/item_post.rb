class ItemPost < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  belongs_to :item
  accepts_nested_attributes_for :item

  validates :review, presence: true, length: { maximum: 500 }
  validates :image, presence: true 

  enum status: { unopened: 0, start: 1, active: 2, finish: 3, discard: 4, repeat: 5 }
  
end
