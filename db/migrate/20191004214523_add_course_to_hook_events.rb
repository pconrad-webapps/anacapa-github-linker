class AddCourseToHookEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :hook_events, :course, foreign_key: true
  end
end
