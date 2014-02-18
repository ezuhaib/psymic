#source 'http://tokyo-m.rubygems.org'
#source 'http://mirror1.prod.rhcloud.com/mirror/ruby/'
source 'https://rubygems.org'

# Baseline
gem 'rails', '3.2.16'
gem 'rake'
gem 'jbuilder'
gem 'pg'

# Analytics
gem 'rack-mini-profiler'
gem 'google-analytics-rails'
gem 'exception_notification'

# Unix-only gems
platforms :ruby do
	gem 'unicorn'
end

platforms :mswin, :mingw do
	gem 'win32console'
end

# Development tools
group :development do
	gem 'webrick'
	gem 'sqlite3'
	gem 'yaml_db'
	gem 'capistrano', '~> 2.15.5'
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'meta_request' #For Rails Panel
	gem 'quiet_assets'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# Simple CSS and JS includes
gem 'jquery-rails'
gem 'bootstrap_form'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'

# Authentication and Authorization
gem 'devise'
gem 'cancan'

# Gems introducing new Models
gem 'acts-as-taggable-on'
gem 'unread'

# Usability and UI
gem 'liquid'
gem 'dotiw'
gem 'country_select'
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'friendly_id', '~> 4.0.10.1'

# Search engine
gem 'searchkick'