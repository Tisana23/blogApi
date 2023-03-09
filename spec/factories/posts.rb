FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { Faker::Boolean.boolean }
    user

    after(:build) do |post, _|
      post.user.save
      post.user_id = post.user.id
    end
  end
end
