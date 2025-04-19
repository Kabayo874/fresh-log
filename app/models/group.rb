class Group < ApplicationRecord

  belongs_to :owner_user, class_name: 'User', foreign_key: 'owner_id'

  has_one_attached :image

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :items, dependent: :destroy

end
