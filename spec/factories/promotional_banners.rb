FactoryBot.define do
  factory :promotional_banner do
    title { "MyString" }
    link { "MyURL" }
    alt { "MyString" }
    width { 1 }
    height { 1 }
    image_file_name { "testsku.jpg" }
    image_content_type { "image/jpg" }
    image_file_size { 1 }
    image_updated_at { "2020-04-28 11:41:19" }
    mobile_image_file_name { "testsku.jpg" }
    mobile_image_content_type { "image/jpg" }
    mobile_image_file_size { 1 }
    mobile_image_updated_at { "2020-04-28 11:41:19" }
    location { 1 }
  end
end
