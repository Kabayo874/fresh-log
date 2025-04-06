class Group < ApplicationRecord

  has_one_attached :image

  has_many :group_members, dependent: :destroy
  has_many :items, dependent: :destroy
  belongs_to :user

end
