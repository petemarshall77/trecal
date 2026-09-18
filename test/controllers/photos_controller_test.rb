require "test_helper"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  PIXEL_PNG = Base64.decode64(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/iZk9HQAAAABJRU5ErkJggg=="
  )

  setup do
    sign_in_as(User.take)
    Photo.find_each do |photo|
      photo.image.attach(io: StringIO.new(PIXEL_PNG), filename: "pixel.png", content_type: "image/png")
    end
  end

  test "all_images includes the show-dates toggle" do
    get all_images_photos_path

    assert_response :success
    assert_select "[data-controller='date-toggle']"
    assert_select "input[type=checkbox][data-date-toggle-target='checkbox']"
    assert_select "span[data-date-toggle-target='label']", minimum: 1
    assert_select "span[data-date-toggle-target='caption']", minimum: 1
  end
end
