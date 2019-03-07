class CreateGeneralMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :general_messages, id: :uuid do |t|
      t.string :body
      t.string :number
    end
  end
end
