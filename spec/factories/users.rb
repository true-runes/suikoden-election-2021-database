FactoryBot.define do
  factory :user do
    id_number { 192789663528910849 }
    name { 'My name is test' }
    screen_name { 'test_screen_name' }
    profile_image_url_https { 'https://pbs.twimg.com/profile_images/1123471964058914816/a8sXngWB_400x400.png' }
    is_protected { false }
  end
end
