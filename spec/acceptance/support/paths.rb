module NavigationHelpers
  def homepage
    "/"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
