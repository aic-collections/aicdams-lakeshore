class ListPresenter
  include Hydra::Presenter

  def to_s
    model.pref_label
  end

  delegate :members, to: :model

  def member_list
    list = []
    members.each do |m|
      list << [m.pref_label, member_description(m), m.id]
    end
    list
  end

  private

    def model
      @model ||= to_model
    end

    def member_description(item)
      return "No description available" if item.description.empty?
      item.description.join("<br />")
    end
end
