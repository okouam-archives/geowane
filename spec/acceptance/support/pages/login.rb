module Pages
  class Login

    URL = "/"

    def initialize(session)
      @session = session
    end

    def visit
      @session.visit URL
    end

    def fill_in_username(login)
      @session.fill_in("user_session_login", with: login)
    end

    def fill_in_password(password)
      @session.fill_in("user_session_password", with: password)
    end

    def fill_in_credentials(user)
      fill_in_username(user.login)
      fill_in_password(user.password)
    end

    def login(user = nil)
      fill_in_credentials(user) if user
      @session.click_button "user_session_submit"
    end

  end
end