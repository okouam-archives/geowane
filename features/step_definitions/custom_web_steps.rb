And /I debug/ do
  debugger
  puts "Debugging..."
end

When /^I attach the file "([^"]*)" from the folder "([^"]*)" for "([^"]*)"$/ do |filename, folder, target|
  path = File.join(Rails.root, folder, filename)
  attach_file(target, path)
end