require_relative '../../app/lib/card_data_scraper'
include RSpec
require 'rspec'

describe CardDataScraper do
    describe "normalize_rules_text" do 
        context "translates all image tags into their alt in paranthesis" do 
            it "translates and image of a tap symbol to (Tap)" do 
                expect(CardDataScraper.normalize_rules_text("It loses all abilities and has <img src=\"/Handlers/Image.ashx?size=small&amp;name=tap&amp;type=symbol\" alt=\"Tap\" align=\"absbottom\">: Remove")).to eq("It loses all abilities and has (Tap): Remove")
            end

        end 

        context "works with multiple images" do 
            it "translates a segment with 2 tap symbols" do 
                expect(CardDataScraper.normalize_rules_text("AB<img src=\"test alt=\"Tap\" sadf> CD <img src=\"test alt=\"Blue\"> e")).to eq("AB(Tap) CD (Blue) e") 
            end 
        end

    end

    describe "searchify_name" do 
        it "adds quoutes around the string and replaces whitespace with %20" do
            expect(CardDataScraper.searchify_name("Theros Beyond Death")).to eq("\"Theros%20Beyond%20Death\"")
        end 
    end

    describe "pull_set" do 
        pull_data = CardDataScraper.pull_set("Theros Beyond Death")
        it "pulls a card from the first page of results" do
            data = CardDataScraper.pull_set("Theros Beyond Death")
            expect(data.find{|x| x[:name]=="Elspeth Conquers Death"}).to be_truthy
            expect(data.find{|x| x[:name]=="Loathsome Chimera"}).to be_truthy
            expect(data.find{|x| x[:name]=="Hateful Eidolon"}).to be_truthy
            expect(data.find{|x| x[:name]=="Omen of the Sea"}).to be_truthy
            expect(data.find{|x| x[:name]=="Calix, Destiny's Hand"}).to be_truthy
            expect(data.find{|x| x[:name]=="Alseid of Life's Bounty"}).to be_truthy

        end
    end
end