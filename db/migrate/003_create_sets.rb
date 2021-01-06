class CreateSets <ActiveRecord::Migration[5.1]
    def change 
        create_table :sets do |t|
            t.string :name
            t.Date :release_date
            t.string :timestamp
        end
    end 
end