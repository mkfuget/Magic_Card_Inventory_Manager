class CreateCardInstances <ActiveRecord::Migration[5.1]
    def change 
        create_table :card_instances do |t|
            t.belongs_to :user
            t.belongs_to :card 
            t.integer :count
            t.string :timestamp
        end
    end 
end