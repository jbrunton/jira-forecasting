class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :self
      t.string :key
      t.string :summary
      t.string :issue_type
      t.string :size
      t.references :epic, index: true
      t.timestamp :started
      t.timestamp :completed

      t.timestamps null: false
    end
  end
end
