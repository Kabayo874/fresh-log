class Group < ApplicationRecord

  has_one_attached :image

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :items, dependent: :destroy

end
