class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :self
      t.string :key
      t.string :summary
      t.string :issue_type

      t.timestamps null: false
    end
  end
end
