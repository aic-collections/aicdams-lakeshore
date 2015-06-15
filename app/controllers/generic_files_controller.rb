class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  self.presenter_class = AssetPresenter
  self.edit_form_class = AssetEditForm

end
