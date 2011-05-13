module Pages
  module Location
    class Edit < Pages::Page

      def save
        @session.find(".block_head ul li a.save").click()
      end

    end
  end
end