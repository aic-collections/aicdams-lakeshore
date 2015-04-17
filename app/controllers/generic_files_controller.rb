class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  self.presenter_class = ResourcePresenter
  self.edit_form_class = ResourceEditForm
end
