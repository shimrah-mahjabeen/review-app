class CreateFollowRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :follow_relationships do |t|
      t.bigint :follower_id, null: false
      t.bigint :followee_id, null: false

      t.timestamps
    end

    add_foreign_key :follow_relationships, :users, column: :follower_id
    add_foreign_key :follow_relationships, :users, column: :followee_id
  end
end
