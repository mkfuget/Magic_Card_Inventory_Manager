class CreateCards <ActiveRecord::Migration[5.1]
    def change 
        create_table :cards do |t|
            t.string :name
            t.string :mana_cost
            t.string :cmc
            t.string :rules_text
            t.string :card_type
            t.belongs_to :card_set
            t.string :timestamp
        end
    end 
end