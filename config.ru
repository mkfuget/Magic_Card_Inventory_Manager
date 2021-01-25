require './app/controllers/application_controller'
require './config/environment'
use Rack::MethodOverride
run ApplicationController
