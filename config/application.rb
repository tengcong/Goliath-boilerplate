Dir["./config/initializers/*.rb"].each { |f| require f }
Dir["./app/models/*.rb"].each { |f| require f }

require './app/api'
