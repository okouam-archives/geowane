module Pages
  class Page

    def initialize(session)
      @session = session
    end

    def url
      raise "This needs to be overriden"
    end

    def visit
      @session.visit self.url
    end

    def has_menu_item?(text)
      is_present?('li a', text)
    end

    def has_title?(text)
      is_present?('title', text)
    end

    private

    def is_present?(selector, text)
       begin
        @session.find(selector, :text => text)
        true
      rescue
        false
      end
    end

  end

end