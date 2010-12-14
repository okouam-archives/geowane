module LocationsHelper

  def show_search_criteria
    return "None" unless params[:s]    
    html = ""
    if category_id = params[:s][:category_id_eq]
      html += " &nbsp; Category: #{Category.find(category_id).french}" unless category_id.blank?
    end
    if city_id = params[:s][:city_id_eq]
      html += " &nbsp; City: #{City.find(city_id).name}" unless city_id.blank?
    end
    if commune_id = params[:s][:commune_id_eq]
      html += " &nbsp; Commune: #{Commune.find(commune_id).name}" unless commune_id.blank?
    end
    if region_id = params[:s][:region_id_eq]
      html += " &nbsp; Region: #{Region.find(region_id).name}" unless region_id.blank?
    end
    if country_id = params[:s][:country_id_eq] 
      html += " &nbsp; Country: #{Country.find(country_id).name}" unless country_id.blank?
    end
    if added_after = params[:s][:added_on_after]
      html += " &nbsp; Added after: #{added_after}" unless added_after.blank?
    end    
    if added_before = params[:s][:added_on_before]
      html += " &nbsp; Added before: #{added_before}" unless added_before.blank?
    end
    html.blank? ? "None" : html.html_safe  
  end

  def workflow_actions(user, object)
    Location.workflow_states.select do |state|
       user.may_change_status_of_location? object, state
    end
  end

  def show_informational_message(msg)
    "<div class='info-message'>#{msg}</div>".html_safe  
  end

end