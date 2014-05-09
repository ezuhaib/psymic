#source 'http://tokyo-m.rubygems.org'
#source 'http://mirror1.prod.rhcloud.com/mirror/ruby/'
source 'https://rubygems.org'

# Baseline
gem 'rails' , '~>4.1.0'
gem 'rake'
gem 'jbuilder'
gem 'pg'
gem 'whenever'
gem 'sitemap_generator'

# Search and analytics
gem 'rack-mini-profiler'
gem 'google-analytics-rails'
gem 'exception_notification'
gem "paperclip"
gem "papercrop", github: "ezuhaib/papercrop"
gem 'searchkick'

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
	gem 'capistrano-rails'
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'meta_request' #For Rails Panel
	gem 'quiet_assets'
	gem 'sextant'
	gem 'rails-web-console'
	gem 'progress_bar'
	gem 'sepastian-capistrano3-unicorn', :require => false
	gem "letter_opener"
end

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'turbo-sprockets-rails3'
gem 'jquery-rails'

# Authentication and Authorization
gem 'devise'
gem 'cancancan'

# Gems introducing new Models
gem 'acts-as-taggable-on'
gem 'unread'
gem 'public_activity'

# Usability and UI
gem 'liquid'
gem 'country_select'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'friendly_id'
gem 'bootstrap_form'
gem 'bootstrap-sass'
gem 'rinku'
gem 'premailer-rails'
gem 'nokogiri' , '1.6.2.rc2' #for premailer-rails

# For rails 4
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'turbolinks'
