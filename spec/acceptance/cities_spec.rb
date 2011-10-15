feature "Cities", %q{
  In order to manage city locations
  As an administrator
  I want to create and delete cities
} do

  background do
    #user has logged on as an administrator
  end

  scenario "Create new city" do
    visit '/cities'
    #click on new city
    #enter city name
    #click submit
    #check city appears in list
  end

  scenario "Delete city" do
    #create city in database
    visit '/cities'
    #show all cities
    #click newly created city
    #click delete
    #check city has disappeared
  end

end