require 'open-uri'
require 'nokogiri'

class CardDataScraper
    def self.pull_set(set_name)
        index = 0
        output_set_data = []
        url = "https://gatherer.wizards.com/Pages/Search/Default.aspx?page=0&action=advanced&set=+[#{searchify_name(set_name)}]"
        html = Nokogiri::HTML(URI.open(url))
        page_numbers_array = html.css('#ctl00_ctl00_ctl00_MainContent_SubContent_topPagingControlsContainer a').text
        page_numbers = page_numbers_array[page_numbers_array.length-3].to_i#gets second to last number which matches to the total number of pages
        loop do 
            url = "https://gatherer.wizards.com/Pages/Search/Default.aspx?page=#{index}&action=advanced&set=+[#{searchify_name(set_name)}]"
            html = Nokogiri::HTML(URI.open(url))
            input_set_data = html.css('div.cardInfo')
            input_set_data.each do |card|
                card_data_hash = {}
                card_data_hash[:name] = card.css('span.cardTitle').text.strip
                mana_cost_data = card.css('span.manaCost')
                mana_cost_string = ""
                mana_cost_data.each do |element|
                    mana_cost_string += "#{element.css('img').attribute("alt")}"
                end
                card_data_hash[:mana_cost] = mana_cost_string.strip
                card_data_hash[:cmc] = card.css('span.convertedManaCost').text.strip

                card_data_hash[:type] = card.css('span.typeLine').text.strip
                rules_text_data = card.css('div.rulesText')
                rules_text_string = ""
                rules_text_data.each do |element|
                    element.css('p').each do |p_element|
                        rules_text_string += normalize_rules_text(p_element.inner_html).strip
                    end 
                end
                card_data_hash[:rules_text] = rules_text_string
                output_set_data.push(card_data_hash)
            end
            index+=1
            if(index>=page_numbers)
                break
            end

        end
        output_set_data
    end

    def self.normalize_rules_text(text) #replace image tags in the source rules text with the value listed in alt
        img_tag_match  = /<img.*?>/
        img_tags = text.scan(img_tag_match)
        translate_tags = img_tags.collect{|x| x.match(/alt=\"(.*?)\"/)[1]}
        translate_tags.each do |translate|
            text.sub!(img_tag_match, "(#{translate})")
        end
        text
    end

    def self.searchify_name(name) #replaces name spaces with %20 to be used in searches and adds quotes
        "\"#{name.split(" ").join("%20")}\""
    end

end