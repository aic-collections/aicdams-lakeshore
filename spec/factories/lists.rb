FactoryGirl.define do
  factory :list do
    pref_label "List of things"
    edit_users ["user2"]

    factory :private_list do
      edit_users []
    end
  end

  factory :list_item do
    pref_label "Item 1"
  end
end
