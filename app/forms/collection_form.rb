# frozen_string_literal: true
class CollectionForm < Sufia::Forms::CollectionForm
  delegate :depositor, :dept_created, :permissions, to: :model
  include HydraEditor::Form::Permissions
end
