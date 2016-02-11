module SessionSupport
  def sign_in(who = :user)
    user = who.is_a?(User) ? who : FactoryGirl.find_or_create(who)
    driver_name = "rack_test_authenticated_header_#{user.email}".to_s
    Capybara.register_driver(driver_name) do |app|
      Capybara::RackTest::Driver.new(app,
                                     respect_data_method: true,
                                     headers: { 'HTTP_SAML_UID' => user.email,
                                                'HTTP_SAML_PRIMARY_AFFILIATION' => user.department
                                              })
    end
    Capybara.current_driver = driver_name
  end

  def sign_in_with_js(who = :user)
    user = who.is_a?(User) ? who : FactoryGirl.find_or_create(who)

    Capybara.register_driver :poltergeist do |app|
      driver = Capybara::Poltergeist::Driver.new(app, js_errors: true, timeout: 90)
      driver.headers = { 'SAML_UID' => user.email, 'SAML_PRIMARY_AFFILIATION' => user.department }
      driver
    end

    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
  end
end
