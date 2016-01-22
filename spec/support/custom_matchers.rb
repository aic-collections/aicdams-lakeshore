module CustomMatchers
  def match_edit_label(label, opts)
    within('div.generic_file_'.+label.to_s) do
      expect(page).to have_content(opts.fetch(:with, nil))
    end
  end

  def match_help_link(label)
    expect(page).to have_css("a#generic_file_#{label}_help")
  end

  def facets_for(field, id)
    solr_result = Blacklight.default_index.connection.get("select", params: { q: "id:#{id}", "facet" => "true", "facet.field" => field })
    solr_result["facet_counts"]["facet_fields"][field]
  end
end
