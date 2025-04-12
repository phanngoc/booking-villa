require "test_helper"

class Admin::NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_notifications_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_notifications_show_url
    assert_response :success
  end

  test "should get mark_as_read" do
    get admin_notifications_mark_as_read_url
    assert_response :success
  end

  test "should get mark_all_as_read" do
    get admin_notifications_mark_all_as_read_url
    assert_response :success
  end
end
