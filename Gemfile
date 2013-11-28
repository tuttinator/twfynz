source 'http://rubygems.org'

gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# HAML templating
gem 'haml-rails'

# when 1.2.9 is released by the maintainer, we can stop using this fork:
gem 'xapian-full-alaveteli', '~> 1.2.9.5'
gem 'acts_as_xapian'
gem 'calendar_helper'
gem 'in_place_editing'
gem 'morph'
gem 'will_paginate'
gem 'garb'
gem 'hpricot'
gem 'compass'
gem 'sass-rails'
gem 'compass-rails'
gem 'nokogiri'

group :development do
  # Annotates the database schema for each model
  gem 'annotate'
  
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

  # YARD for generated documentation
  gem 'yard'
  gem 'yard-cucumber'

  # Thin over webbrick in development - because it is evented
  gem 'thin'

end

group :test do
  gem 'cucumber-rails', require: false
  gem 'vcr'
  gem 'fakeweb'
  gem 'fuubar'
  gem 'timecop'
  gem 'selenium-webdriver'
end

