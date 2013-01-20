source 'https://rubygems.org'

gem 'rails', '3.2.11'


# Postgresql database
gem 'pg'

# safer attributes at the controller level
gem 'strong_parameters'

# Pagination gem
gem 'kaminari'

# Devise for use authentication
gem 'devise'

# Spine JS for JS MVC
gem 'spine-rails'
# ECO templating
gem 'eco' 

# HAML templating
gem 'haml-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'disable_assets_logger'
  gem 'turbo-sprockets-rails3'
  # gem 'asset_sync'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  # Annotates the database schema for each model
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git', ref: 'bef0c494956e516540b7a9e72fa03be6576031dd'
  
  # Local mail interceptor - makes it easier to view HTML email
  gem 'mailcatcher', require: false  

  # Guard plugins
  gem 'rb-fsevent', :require => false
  gem 'terminal-notifier-guard'

  # Bullet for SQL optomisations
  # gem 'bullet'

  # Better Errors as a more useful exception debugger
  gem 'better_errors'
  gem 'binding_of_caller'

  # Launchy and capybara for acceptance tests
  gem 'launchy'
  gem 'capybara'

  # Pry as an IRB replacement / debugging tool
  gem 'pry-rails' 

  # YARD fro generated documentation
  gem 'yard'

  # Thin over webbrick in development - because it is evented
  gem 'thin'

end


group :development, :test do
  gem 'jasminerice'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner', require: false
  gem 'guard-rspec', require: false
  gem 'guard-jasmine', require: false
  gem 'guard-cucumber', require: false
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'vcr'
  gem 'fakeweb'
  gem 'fuubar'
  gem 'timecop'
  gem 'selenium-webdriver'
end



# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano', require: false
