require "test_helper"

class Admin::FilterFieldsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_filter_fields_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_filter_fields_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_filter_fields_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_filter_fields_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_filter_fields_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_filter_fields_destroy_url
    assert_response :success
  end
end
