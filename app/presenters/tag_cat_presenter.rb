class TagCatPresenter
  include Hydra::Presenter
  self.model_class = TagCat
  self.terms = [ :pref_label ]

  # Depositor and permissions are not displayed in app/views/generic_files/_show_descriptions.html.erb
  # so don't include them in `terms'.
  delegate :depositor, :permissions, to: :model
end
