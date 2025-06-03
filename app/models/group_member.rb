class GroupMember < ApplicationRecord

  belongs_to :user
  belongs_to :group

  enum exit_reason: {
    voluntary: 0,     # 自主的に脱退
    forced: 1         # 管理者による強制脱退
  }
  
end
