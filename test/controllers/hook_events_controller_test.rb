require 'test_helper'

class HookEventsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    sample_json = <<-JSON
    {
      "sender" : {
        "login" : "pconrad"
      },
      "organization" : {
        "login" : "test-org"
       },
       "repository" : {
         "name" : "test-repo"
       }
    }
    JSON
    @course = Course.first
    @hook_event = HookEvent.create(course_id: @course.id, hooktype:"push", content: sample_json)
    @user = users(:wes)
    @user.add_role(:admin)
    sign_in @user
  end

  test "should get index" do
    get course_hook_events_url(@course.id)
    assert_response :success
  end

  test "should show hook_event" do
    get course_hook_event_url(@course, @hook_event)
    assert_response :success
  end

end
