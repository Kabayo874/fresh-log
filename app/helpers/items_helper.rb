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
end
