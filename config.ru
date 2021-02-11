require './config/environment'
# require 'rack-flash'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use DecksController
use UsersController
use CardsController
run ApplicationController