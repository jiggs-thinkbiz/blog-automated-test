FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph(2) }
    email { Faker::Internet.email }

    trait :published do
      
    end
  end
end
