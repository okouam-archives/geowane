module LocationsHelper

  def show_search_criteria
    return "None" unless params[:s]    
    html = ""
    if category_id = params[:s][:category_id]
      html += " &nbsp; Category: #{Category.find(category_id).french}" unless category_id.blank?
    end
    if city_id = params[:s][:city_id]
      html += " &nbsp; City: #{City.find(city_id).name}" unless city_id.blank?
    end
    if commune_id = params[:s][:commune_id]
      html += " &nbsp; Commune: #{Commune.find(commune_id).name}" unless commune_id.blank?
    end
    if region_id = params[:s][:region_id]
      html += " &nbsp; Region: #{Region.find(region_id).name}" unless region_id.blank?
    end
    if country_id = params[:s][:country_id] 
      html += " &nbsp; Country: #{Country.find(country_id).name}" unless country_id.blank?
    end
    if name = params[:s][:name] 
      html += " &nbsp; Name: #{name}" unless name.blank?
    end
    if added_after = params[:s][:added_on_after]
      html += " &nbsp; Added after: #{added_after}" unless added_after.blank?
    end    
    if added_before = params[:s][:added_on_before]
      html += " &nbsp; Added before: #{added_before}" unless added_before.blank?
    end
    if added_by = params[:s][:added_by]
      html += " &nbsp; Added before: #{added_by}" unless added_by.blank?
    end
    if audited_by = params[:s][:audited_by]
      html += " &nbsp; Audited by: #{audited_by}" unless audited_by.blank?
    end
    if modified_by = params[:s][:modified_by]
      html += " &nbsp; Modified by: #{modified_by}" unless modified_by.blank?
    end
    if confirmed_by = params[:s][:confirmed_by]
      html += " &nbsp; Confirmed by: #{confirmed_by}" unless confirmed_bye.blank?
    end
    if category_missing = params[:s][:category_missing]
      html += " &nbsp; Without Any Tags" unless category_missing.blank?
    end
    if category_present = params[:s][:category_present]
      html += " &nbsp; With Tags" unless category_present.blank?
    end
    html.blank? ? "None" : html.html_safe  
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
