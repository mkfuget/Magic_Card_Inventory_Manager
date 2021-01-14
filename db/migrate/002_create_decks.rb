class CreateDecks <ActiveRecord::Migration[5.1]
    def change 
        create_table :cards do |t|
            t.string :name
            t.string :timestamp
        end
    end 
end