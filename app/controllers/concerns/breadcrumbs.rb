module Breadcrumbs
  include Sufia::Breadcrumbs

  def add_breadcrumb_for_action
    edit_generic_files
    edit_works
    edit_actors
    edit_exhibitions
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
    
    def edit_actors
      return unless /edit/ =~ action_name && controller_name == "actors"
      add_breadcrumb "View Actor", actor_path(params["id"])
    end

    def edit_exhibitions
      return unless /edit/ =~ action_name && controller_name == "exhibitions"
      add_breadcrumb "View Exhibition", exhibition_path(params["id"])
    end
end
