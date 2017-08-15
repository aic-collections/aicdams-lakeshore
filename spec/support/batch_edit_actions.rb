# frozen_string_literal: true
module BatchEditActions
  def fill_in_batch_edit_field(id, opts = {})
    within "#form_#{id}" do
      fill_in "generic_work_#{id}", with: opts.fetch(:with, "NEW #{id}")
      click_button "#{id}_save"
    end
    within "#form_#{id}" do
      sleep 0.1 until page.text.include?('Changes Saved')
      expect(page).to have_content 'Changes Saved', wait: Capybara.default_max_wait_time * 4
    end
  end

  def batch_edit_fields
    ["publisher", "language"]
  end
end
