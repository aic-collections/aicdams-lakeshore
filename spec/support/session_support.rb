# frozen_string_literal: true
require 'capybara/poltergeist'

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

  def sign_in_with_js(who = :user, opts = {})
    sign_in_with_named_js(:poltergeist, who, opts)
  end

  def sign_in_with_named_js(name, who = :user, opts = {})
    opts.merge!(disable_animations) if opts.delete(:disable_animations)
    user = who.is_a?(User) ? who : FactoryGirl.find_or_create(who)

    Capybara.register_driver name do |app|
      Capybara::Poltergeist::Driver.new(app, defaults.merge(opts))
    end
    Capybara.current_driver = name
    page.driver.headers = { 'SAML_UID' => user.email, 'SAML_PRIMARY_AFFILIATION' => user.department }
  end

  def disable_animations
    { extensions: ["#{Rails.root}/spec/support/disable_animations.js"] }
  end

  private

    def defaults
      {
        js_errors: true,
        timeout: 90,
        phantomjs_options: ['--ssl-protocol=ANY']
      }
    end
end
