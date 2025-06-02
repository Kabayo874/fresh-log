module ApplicationHelper
  def active_user?(user)
    user.present? && !user.withdrawn?
  end

  def withdrawn_badge(user)
    return unless user && !active_user?(user)
    content_tag(:span, "退会済み", class: "badge bg-secondary ms-1")
  end
  
  
end
