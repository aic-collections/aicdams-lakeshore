FactoryGirl.define do
  factory :user do
    factory :user1 do
      email 'user1'
      department '100'
    end

    factory :user2 do
      email 'user2'
      department '200'
    end

    factory :admin do
      email 'admin'
      department '100'
    end
  end
end
