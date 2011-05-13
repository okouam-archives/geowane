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
        puts @session.find("table tr a", name).find("..").inspect
      end

      def is_on_page?(num)
        @session.has_css?('.paggination em', text: num.to_s)
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
