json.extract! course_hook_event, :id, :course_id, :hooktype, :content, :created_at, :updated_at
json.url course_hook_event_url(@parent, hook_event, format: :json)
