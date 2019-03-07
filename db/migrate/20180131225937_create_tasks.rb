class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks, id: :uuid do |t|
      t.date :due_date
      t.string :name
      t.datetime :completed_at
      t.references :recruit, type: :uuid
    end
  end
end
