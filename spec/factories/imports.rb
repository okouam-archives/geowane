Factory.define :valid_gpx_import, :class => Import do |f|
  f.input_format "GPX"
  f.association :user, :factory => :valid_collector
end

