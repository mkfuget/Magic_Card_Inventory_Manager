require 'bundler'
Bundler.require

configure :development do
	set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
end
require_relative '../app/application_controller.rb'
require_relative '../app/models/card_instance.rb'
require_relative '../app/models/card.rb'
require_relative '../app/models/deck.rb'
require_relative '../app/models/card_set.rb'
require_relative '../app/models/user.rb'
