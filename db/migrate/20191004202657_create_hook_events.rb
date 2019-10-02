class CreateHookEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :hook_events do |t|
      t.string :hooktype
      t.string :content
      t.timestamps
    end
  end
end
