module ApplicationHelper
  def active_user?(user)
    user.present? && !user.withdrawn?
  end
  
end
