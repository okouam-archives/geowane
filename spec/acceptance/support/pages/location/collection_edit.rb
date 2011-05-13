module Pages
  module Location
    class CollectionEdit < Pages::Page

      def commit_changes
        @session.find("#actions input").click
      end

    end
  end
end
