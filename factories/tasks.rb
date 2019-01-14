FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'Rspecのテストデータを用意' }
    user
  end
end

