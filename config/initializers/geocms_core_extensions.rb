Array.class_eval do
  include CoreExtensions::Array
end

if defined? ActiveRecord
  ActiveRecord::Base.class_eval do
    include CoreExtensions::ActiveRecord::Base
  end
end

if defined? ActiveRecord
  ActiveRecord::Base.send :include, CoreExtensions::ActiveRecord::HasSerializedAssociation
end


