module Pages
  module Export
    class Index < Pages::Page

      def initialize(session)
        @session = session
      end

      def url
        "/exports"
      end

      def create_selection

      end

    end
  end
end
