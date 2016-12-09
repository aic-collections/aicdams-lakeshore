# frozen_string_literal: true
module AICAssetAfterDeleteBehavior
  def report_status_and_redirect(assets_with_relationships, batch:)
    if assets_with_relationships.empty?
      if flash[:error].nil?
        flash[:notice] = success_msg(batch: batch)
        status = 200
      else
        status = 500
      end
    else
      flash[:error] = "These assets were not deleted because they have resources linking to them: #{assets_with_relationships.join}."
    end
    respond_to do |wants|
      wants.html { redirect_to main_app.search_catalog_path }
      wants.json { render_json_response(status: status) }
    end
  end

  def success_msg(batch:)
    if batch == true
      "Batch was successfully deleted."
    else
      "Asset was successfully deleted."
    end
  end
end
