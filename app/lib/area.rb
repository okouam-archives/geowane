module Area

  def self.included(base)

    base.class_eval do

      resource_controller

      edit.wants.html do
        render "shared/name_change"
      end

      update.wants.html do
        redirect_to collection_path
      end

      index.before do
        @can_edit = current_user.send "may_update_#{model_name}?", collection.first
      end

      def collection
        @collection = model_name.find_by_sql(collection_sql)
      end

      def model_name
        self.class.to_s.sub(/Controller/, "").singularize.constantize
      end

    end

  end

end

