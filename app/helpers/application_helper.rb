module ApplicationHelper

  def linked_figure(figure, url)
    if figure > 0 && url
      "<a href=\"#{url}\">#{number_with_delimiter(figure, :separator => ",")}</a>".html_safe
    else
      number_with_delimiter(figure).html_safe
    end
  end

end
