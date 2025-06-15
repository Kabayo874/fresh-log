module GroupsHelper
  def toggle_sort(current_sort, column)
    if current_sort == "#{column}_asc"
      "#{column}_desc"
    else
      "#{column}_asc"
    end
  end

  def sort_icon(current_sort, column)
    if current_sort == "#{column}_asc"
      "▲"
    elsif current_sort == "#{column}_desc"
      "▼"
    else
      ""
    end
  end
end
