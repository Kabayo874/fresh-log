module ItemsHelper
  def category_color_class(category)
    case category
    when "cosmetics"
      "btn-cosmetics"
    when "daily_necessities"
      "btn-daily"
    when "groceries"
      "btn-food"
    when "supplement"
      "btn-supplement"
    else
      "btn-light"
    end
  end

  def status_color_class(status)
    case status
    when "unopened"
      "btn-unopened"
    when "start"
      "btn-start"
    when "active"
      "btn-active"
    when "finish"
      "btn-finish"
    when "discard"
      "btn-discard"
    when "repeat"
      "btn-repeat"
    else
      "btn-light"
    end
  end
  
end
