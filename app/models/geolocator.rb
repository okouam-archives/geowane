class Geolocator

  def normalize(text)
    return "" if text.blank?
    text.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
  end

  def create_unique_name(location)
    return "" if location.name.blank?
    label = location.name
    label += ", #{location.commune.name}" if location.commune
    label += ", #{location.city.name}" if location.city
    label += ", #{location.region.name}" if location.region
    label
  end

end