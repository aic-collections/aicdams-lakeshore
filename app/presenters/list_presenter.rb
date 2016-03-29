class ListPresenter
  include Hydra::Presenter

  Struct.new("ListItemPresenter", :pref_label, :description, :id, :deletable?)

  def to_s
    model.pref_label
  end

  def selector
    "#{model.pref_label.parameterize}_list"
  end

  delegate :members, to: :model

  def member_list
    list = []
    members.each do |m|
      list << Struct::ListItemPresenter.new(m.pref_label, member_description(m), m.id, deletable?(m))
    end
    list.sort { |a, b| a.pref_label <=> b.pref_label }
  end

  def description
    model.description.empty? ? "No description available" : model.description
  end

  def editable_by(user)
    user.can?(:edit, model)
  end

  private

    def member_description(item)
      return "No description available" if item.description.empty?
      item.description.join("<br />")
    end

    def deletable?(item)
      StatusType.active.id != item.id
    end
end
