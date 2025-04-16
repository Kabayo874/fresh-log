class ItemPost < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  belongs_to :item

  enum status: { active: 0, finish: 1, discard: 2, repeat: 3 }

end
