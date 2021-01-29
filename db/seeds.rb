require_relative "../app/lib/card_data_scraper"
CardDataScraper.reset_database
sets = [
    {:name => "Throne of Eldraine", :release_date => Date.new(2019, 10, 4)},
    {:name => "Theros Beyond Death", :release_date => Date.new(2020, 1, 24)},
    {:name => "Ikoria: Lair of Behemoths", :release_date => Date.new(2020, 4, 17)},
    {:name => "Core Set 2021", :release_date => Date.new(2020, 7, 3)},
    {:name => "Zendikar Rising", :release_date => Date.new(2020, 9, 25)},
    {:name => "Kaldheim", :release_date => Date.new(2020, 1, 28)}

] 

sets.each do |set|
    make_set = CardSet.create(set)
    CardDataScraper.pull_set(make_set.name).each do |set_card|
        make_set.cards << Card.create(set_card)
    end
end

