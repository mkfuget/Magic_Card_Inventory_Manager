class CreateCardSets <ActiveRecord::Migration[5.1]
    def change 
        create_table :card_sets do |t|
            t.string :name
            t.datetime :release_date
            t.string :timestamp
        end
    end 
end