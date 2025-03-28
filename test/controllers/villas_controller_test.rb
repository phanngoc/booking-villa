require "test_helper"

class VillasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get villas_index_url
    assert_response :success
  end

  test "should get show" do
    get villas_show_url
    assert_response :success
  end
end
