module LocationsHelper


  def feature_information_wrapper(attribute, location, &block)
    value = location.send(attribute)
    display = value.nil? || value.empty? ? "none" : "block"
    html = "<div style='display: #{display}'>" + capture(&block) + "</div>"
    html.html_safe
  end

  def workflow_actions(user, object = nil)
    if object
      allowed_states = Location.new.enums(:status).select_options.select do |state|
         user.may_change_status_of_location? object, state[1].to_sym
      end
    else
      allowed_states = Location.new.enums(:status).select_options
    end
    allowed_states.map {|x| [x[0].upcase, x[1]]}
  end

  def show_informational_message(msg)
    "<div class='info-message'>#{msg}</div>".html_safe  
  end

end
