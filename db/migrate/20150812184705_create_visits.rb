class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|

      t.integer :visitor_id
      t.integer :shortened_url_id

      t.timestamps

    end
    add_index :visits, :visitor_id
    add_index :visits, :shortened_url_id
  end
end
