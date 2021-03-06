require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  fixtures :users
  test 'each place can return the weather' do
    place = Place.new(
      favorite_memory: 'going to the beach',
      image_url: 'http://www.example.com/res.png',
      location: 'philly',
      visit_length: '1 week',
      user_id: users(:one).id
    )
    place.save
    weather = place.get_weather
    assert weather[:description], 'weather description exists.'
    assert weather[:temperature], 'temperature exists.'
    assert weather[:icon_url], 'icon url exists.'
    assert_equal weather[:status], 200, 'a valid location returns status code 200.'
  end
  test 'an invalid location returns status 0' do
    place = Place.new(
      favorite_memory: 'going to the beach',
      image_url: 'http://www.example.com/res.png',
      location: '',
      visit_length: '1 week',
      user_id: users(:one).id
    )
    place.save
    weather = place.get_weather
    assert_not_equal weather[:status], 200, 'an invalid location returns default status'
  end
  test 'an image url returns an error' do
    place = Place.new(
      favorite_memory: 'going to the beach',
      image_url: 'http://www.example.com',
      location: 'California',
      visit_length: '1 week',
      user_id: users(:one).id
    )
    place.save
    assert place.invalid?, 'url must end in image extension.'
    assert_equal ["Image must be a URL for GIF, JPG or PNG image. For example: http://cruiseweb.com/admin/Images/image-gallery/rainbow-falls-hawaii.jpg"], place.errors[:image_url]
  end
end
