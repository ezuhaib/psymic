#source 'http://tokyo-m.rubygems.org'
#source 'http://mirror1.prod.rhcloud.com/mirror/ruby/'
source 'https://rubygems.org'

# Baseline
gem 'rails', '3.2.17'
gem 'rake'
gem 'jbuilder'
gem 'pg'
gem 'whenever'
gem 'sitemap_generator'
#gem 'meta-tags', :require => 'meta_tags'

# Search and analytics
gem 'rack-mini-profiler'
gem 'google-analytics-rails'
gem 'exception_notification'
gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
gem "papercrop", git: "https://github.com/ezuhaib/papercrop.git"
gem 'searchkick', git: "https://github.com/ankane/searchkick.git"

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
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'turbo-sprockets-rails3'
end

# Authentication and Authorization
gem 'devise'
gem 'cancan'

# Gems introducing new Models
gem 'acts-as-taggable-on'
gem 'unread'
gem 'public_activity'

# Usability and UI
gem 'liquid'
#gem 'dotiw'
gem 'country_select'
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'friendly_id', '~> 4.0.10.1'
gem 'bootstrap_form'
gem 'bootstrap-sass', "~> 3.1.1.0"
gem 'rinku'
gem 'premailer-rails'
gem 'nokogiri'