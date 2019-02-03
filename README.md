# minimal sinatra prepared_statements test
The goals of this project is to show that it is impossible to configure `prepared_statements = false` on Heroku only with the database.yml if you used `sinatra 2` and `activerecord 4.2`. Only solution is to used an initializer.

## With only database.yml (master branch of this project)

### Configuration:

Gemfile

```
gem "activerecord",             "~> 4.2.6"
gem "sinatra-activerecord",     "~> 2.0.9"
gem "pg",                       "~> 0.18.4"
gem "rake",                     "~> 11.3.0"
```

database.yml

```
DEFAULTS: &DEFAULTS
  adapter: postgresql
  encoding: UTF8
  pool: 5
  prepared_statements:  false

development:
  <<: *DEFAULTS
  database:             database
  username:             username
  host:                 host


production:
  <<: *DEFAULTS
  host:             <%= ENV['DATABASE_HOST'] %>
  database:         <%= ENV['DATABASE_NAME'] %>
  username:         <%= ENV['DATABASE_USER'] %>
  password:         <%= ENV['DATABASE_PASSWORD'] %>
```

### Installation & tests

#### local
```
git clone https://github.com/hugobarthelemy/minimal-sinatra-prepared-statements-test.git
bundle install
rake db:create
rake db:migrate
rake db:seed
make console
ActiveRecord::Base.connection.prepared_statements
=> false
```

### On Heroku
```
git push heroku master:master
heroku run rake db:migrate  --app <app_name>
heroku run rake db:seed     --app <app_name>
heroku run make console     --app <app_name>
ActiveRecord::Base.connection.prepared_statements
=> true
```

## With database.yml and initializer (`with-initializer` branch of this project)
### Configuration

Same as above but with this initializer ( `./app/initializers/disable_prepared_statements.rb` ) :
```
ActiveRecord::Base.establish_connection(
  ActiveRecord::Base.remove_connection.merge(
    :prepared_statements => false
  )
)
```

And add `require` in `app.rb` :
```
require 'sinatra'
require 'sinatra/activerecord'
require './app/models/text.rb'

set :database_file, "config/database.yml"
require './app/initializers/disable_prepared_statements.rb'

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get "/" do
    Text.first.content
  end
end
```

### Installation & tests

#### local
```
git clone https://github.com/hugobarthelemy/minimal-sinatra-prepared-statements-test.git
git checkout with-initializer
bundle install
rake db:create
rake db:migrate
rake db:seed
make console
ActiveRecord::Base.connection.prepared_statements
=> false
```

### On Heroku
```
git push heroku with-initializer:master
heroku run rake db:migrate  --app <app_name>
heroku run rake db:seed     --app <app_name>
heroku run make console     --app <app_name>
ActiveRecord::Base.connection.prepared_statements
=> false
```
