module Breadcrumbs
  include Sufia::Breadcrumbs

  def add_breadcrumb_for_action
    edit_generic_files
    edit_works
    edit_actors
    edit_exhibitions
    edit_transactions
    edit_shipments
    show_list
    index_list
    edit_list
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

    def edit_transactions
      return unless /edit/ =~ action_name && controller_name == "transactions"
      add_breadcrumb "View Transaction", transaction_path(params["id"])
    end

    def edit_shipments
      return unless /edit/ =~ action_name && controller_name == "shipments"
      add_breadcrumb "View Shipment", shipment_path(params["id"])
    end

    def show_list
      return unless /show/ =~ action_name && controller_name == "lists"
      add_breadcrumb "Lists", lists_path
      add_breadcrumb "View List"
    end

    def index_list
      return unless /index/ =~ action_name && controller_name == "lists"
      add_breadcrumb "Lists"
    end

    def edit_list
      return unless /edit/ =~ action_name && controller_name == "lists"
      add_breadcrumb "Lists", lists_path
      add_breadcrumb "Edit List"
    end
end
