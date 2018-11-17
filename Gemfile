source 'https://rubygems.org'
ruby '2.3.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0'
# Use postgeSQL as the database for Active Record
gem 'pg', '~> 0.21.0'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# use jquery-ui
gem 'jquery-ui-rails'
# Use slim for templates
gem 'slim-rails'
# Use simple form forms
gem 'simple_form'
# css framework
# gem 'foundation-rails'
# for WYSIWYG editor
gem 'tinymce-rails'
# for vanity URLS
gem 'friendly_id', '~> 5.1.0'
# for video display
gem 'video_info'
# for autocomplete inputboxes
gem 'rails-jquery-autocomplete'
# for remote file uploads
gem 'remotipart', '~> 1.2', github: 'pedantix/remotipart', ref: '7f7989db572976816c03508c335bbc1d8230af78'
gem 'jquery-fileupload-rails', github: 'Springest/jquery-fileupload-rails'
# for in line editing
# gem 'rest_in_place'

# for font awesome
gem "font-awesome-rails"

#date validations
gem 'date_validator'

#progress bars
# gem 'nprogress-rails'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# application configuration
gem 'figaro'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
##Omniauth authntication
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem "omniauth-google-oauth2"
# for country selects
gem 'country_select'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# for authorization
gem 'pundit'
# for state
gem 'aasm'
# for documentation
gem 'yard', '~> 0.9.11'
#geocoding
gem 'geocoder'
# for images
gem 'dragonfly'
# for errors
gem 'rollbar'

#full text search
gem 'pg_search'

gem 'truncate_html'
gem 'will_paginate', '~> 3.1.0'
gem 'social-share-button'
gem 'annotate'
gem 'listen', '~> 3.0.5'
gem 'rest-client'


gem 'image_optim'
gem 'image_optim_pack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem "letter_opener"
  gem 'capistrano', '~> 3.10.0'  
  gem 'capistrano-rails'
  gem 'capistrano-rvm', github: "capistrano/rvm"
  gem 'capistrano-bundler'
  gem 'capistrano3-puma',   require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  
end

group :test do
  gem 'minitest-capybara'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'minitest-byebug'
end

group :production do
  gem 'execjs'
  gem 'therubyracer', :platforms => :ruby
  #gem 'rack-cache', '~> 1.6.0'
  gem 'rack-cache', :require => 'rack/cache'
  gem "sinatra", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
#gem 'annotate', '2.7.1', require: false

# Added at 2017-11-16 10:39:05 +0300 by kev:
gem "appengine", "~> 0.4.4"
