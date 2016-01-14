module CustomMatchers
  def match_edit_label(label, opts)
    within('div.generic_file_'.+label.to_s) do
      expect(page).to have_content(opts.fetch(:with, nil))
    end
  end
end
