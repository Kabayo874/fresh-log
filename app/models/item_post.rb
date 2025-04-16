class ItemPost < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  belongs_to :item

  enum status: { start: 0, active: 1, finish: 2, discard: 3, repeat: 4 }

end
