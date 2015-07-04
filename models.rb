ActiveRecord::Base.establish_connection(
  ENV['DATABASE_URL']||'sqlite3:db/development.db')

class Contribution < ActiveRecord::Base
end

class User < ActiveRecord::Base
    has_secure_password
end
