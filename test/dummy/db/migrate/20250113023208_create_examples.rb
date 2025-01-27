class CreateExamples < ActiveRecord::Migration[8.0]
  def change
    create_table :examples do |t|
      t.integer :status
      t.integer :value

      t.timestamps
    end
  end
end
