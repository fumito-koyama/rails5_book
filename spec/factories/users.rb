FactoryBot.define do
  factory :user do
    name {'テストユーザー'}
    email { 'tast@example.com' }
    password {'password'}
  end
end
