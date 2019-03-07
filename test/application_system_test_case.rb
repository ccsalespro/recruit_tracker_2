require "test_helper"

Capybara.register_driver :rack_test_ujs do |app|
  Capybara::RackTest::Driver.new(app, respect_data_method: true)
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  [
    "headless",
    "window-size=1280x1280",
  ].each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActiveJob::TestHelper
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  case ENV["CAPYBARA_DRIVER"]
  when "chrome"
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  when "chrome-headless"
    driven_by :selenium_chrome_headless, screen_size: [1400, 1400]
  when "", nil
    driven_by :rack_test_ujs
  else
    raise "unknown Capybara driver"
  end

  def login
    password = "secret123"
    @current_user = FactoryBot.create :user, password: password

    visit new_user_session_path
    fill_in "Email", with: current_user.email
    fill_in "Password", with: password
    click_on "Log in"
  end
  attr_reader :current_user

end
