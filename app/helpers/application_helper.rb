module ApplicationHelper

  def linked_figure(figure, url)
    figure = 0 unless figure
    if figure.to_i > 0 && url
      "<a href=\"#{url}\">#{number_with_delimiter(figure, :separator => ",")}</a>".html_safe
    else
      number_with_delimiter(figure).html_safe
    end
  end

end
