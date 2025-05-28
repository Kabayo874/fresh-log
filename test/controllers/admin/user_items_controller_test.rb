require "test_helper"

class Admin::UserItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_user_items_index_url
    assert_response :success
  end
end
