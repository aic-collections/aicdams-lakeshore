module Breadcrumbs
  include Sufia::Breadcrumbs

  def add_breadcrumb_for_action
    edit_generic_files
    edit_works
  end

  private

    def edit_generic_files
      return unless /edit|stats/ =~ action_name && controller_name == "generic_files"
      add_breadcrumb I18n.t("sufia.generic_file.browse_view"), sufia.generic_file_path(params["id"])
    end

    def edit_works
      return unless /edit/ =~ action_name && controller_name == "works"
      add_breadcrumb "View Work", work_path(params["id"])
    end

end
