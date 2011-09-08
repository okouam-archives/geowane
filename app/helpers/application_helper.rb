module ApplicationHelper

  def linked_figure(figure, url)
    figure = 0 unless figure
    if figure.to_i > 0 && url
      "<a href=\"#{url}\">#{number_with_delimiter(figure, :separator => ",")}</a>".html_safe
    else
      number_with_delimiter(figure).html_safe
    end
  end

  def administrative_unit_finder(depth, row)
    case
      when depth >= 3 && row.level_3_id
        level_id = row.level_3_id
      when depth >= 2 && row.level_2_id
        level_id = row.level_2_id
      when depth >= 1 && row.level_1_id
        level_id = row.level_1_id
      when depth >= 0 && row.level_0_id
        level_id = row.level_0_id
      else
        level_id = "none"
    end
    "s[level_id]=#{level_id}"
  end

  def deferred(&block)
    @deferred_content ||= ""
    @deferred_content << capture(&block)
  end

end
