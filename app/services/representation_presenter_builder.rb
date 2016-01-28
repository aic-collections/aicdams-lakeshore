class RepresentationPresenterBuilder
  attr_reader :model, :citi_uid

  def initialize(params)
    @model = params.fetch(:model, nil)
    @citi_uid = params.fetch(:citi_uid, nil)
  end

  def call
    return unless model && citi_uid && model_class && presenter && resource
    presenter.new(resource)
  end

  private

    def model_class
      model.capitalize.constantize
    rescue NameError
      nil
    end

    def presenter
      "#{model.capitalize}Presenter".constantize
    rescue NameError
      nil
    end

    def resource
      @resource = begin
                    model_class.where("citi_uid_tesim:#{citi_uid}").first
                  rescue RSolr::Error::Http
                    nil
                  end
    end
end
