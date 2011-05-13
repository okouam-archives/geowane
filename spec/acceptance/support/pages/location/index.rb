module Pages
  module Location
    class Index < Pages::Page

      def url
        "/locations"
      end

      def goto_page(num)
        @session.find(".paggination a", :text => num.to_s).click
      end

      def pick_location(name)
        @session.find("table tr a", :text => name).find(:xpath, "../../td[1]/input").click
      end

      def is_on_page?(num)
        @session.has_css?('.paggination em', text: num.to_s)
      end

      def edit_selection
        @session.find('.collection_edit a').click
      end

      def item_at_row(num)
        @session.find(:xpath, "//table/tbody/tr[#{num}]/td[2]/a").text
      end

      def edit_location(name)
        @session.find("table tr a", :text => name).click
      end

    end
  end
end
