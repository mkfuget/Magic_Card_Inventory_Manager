require './config/environment'
use Rack::MethodOverride
use DecksController
use CardInstancesController
use CardsController
use CardSetsController
use UsersController
run ApplicationController
