module UsersHelper

  def toggle_sort(current_sort, field)
    if current_sort == "#{field}_asc"
      "#{field}_desc"
    else
      "#{field}_asc"
    end
  end

  def sort_icon(current_sort, field)
    if current_sort == "#{field}_asc"
      "▲"
    elsif current_sort == "#{field}_desc"
      "▼"
    else
      ""
    end
  end

end
