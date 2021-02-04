class CreateCards < ActiveRecord::Migration[4.2]
    def change 
        create_table :cards do |t|
        t.string :front
        t.string :back
        t.string :deck_id
        end
    end
end