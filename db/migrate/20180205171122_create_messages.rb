class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :body
      t.references :recruit, type: :uuid
      t.boolean :from_recruit, default: false
      t.datetime :read_at
    end
  end
end
