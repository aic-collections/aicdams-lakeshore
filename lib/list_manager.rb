# Manages the membership and types of lists that are used in Lakeshore.
# Using yaml files in the config directory, one list will be created per file.
# If the list or any of its members already exist, then it will not be altered.
class ListManager
  attr_reader :source

  # @param [String] file path to the yaml file
  def initialize(file)
    @source = YAML.load_file(file)
  end

  def exists?
    !List.find_by_label(pref_label).nil?
  end

  def create!
    members.each do |member|
      update_membership_for(member)
    end
  end

  # @param [Hash] member from the list of members in the yaml file
  def update_membership_for(member)
    return if list_has?(member)
    list.members << member_class.new(pref_label: pref_label(member), description: [description(member)])
  end

  # @param [Hash] member
  # returns [Boolean] if the list already has a member with the same pref_label
  def list_has?(member)
    list.members.map(&:pref_label).include?(pref_label(member))
  end

  private

    def pref_label(item = nil)
      item ||= source
      item.fetch("pref_label", nil)
    end

    def description(item = nil)
      item ||= source
      item.fetch("description", nil)
    end

    def members
      source.fetch("members", [])
    end

    def member_class
      pref_label == "Status" ? StatusType : ListItem
    end

    def list
      @list ||= if exists?
                  List.find_by_label(pref_label)
                else
                  List.create(pref_label: pref_label, description: [description])
                end
    end
end
