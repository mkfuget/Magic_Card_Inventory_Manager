class CreateDecks <ActiveRecord::Migration[5.1]
    def change 
        create_table :decks do |t|
            t.string :name
            t.belongs_to :user
            t.string :timestamp
        end
    end 
end