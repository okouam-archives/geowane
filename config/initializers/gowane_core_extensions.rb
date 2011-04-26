Array.class_eval do
  include GowaneCoreExtensions::Array
end

if defined? ActiveRecord
  ActiveRecord::Base.class_eval do
    include GowaneCoreExtensions::ActiveRecord::Base
  end
end

if defined? ActiveRecord
  ActiveRecord::Base.send :include, GowaneCoreExtensions::ActiveRecord::HasSerializedAssociation
end


