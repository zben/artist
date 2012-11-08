source "https://rubygems.org"
ruby "1.9.3"

gem 'rails', '3.2.8'
gem 'haml-rails'
gem 'devise',           '~> 2.0.0'
gem 'devise_invitable', '~> 1.0.0'
gem "nifty-generators", :group => :development
# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem 'nested_form',:git => 'git://github.com/ryanb/nested_form.git'
gem 'thin'
gem 'faker'
gem 'formtastic',:git => 'https://github.com/justinfrench/formtastic.git'
gem 'formtastic-bootstrap'
gem 'active_hash'
gem "seedbank"
gem 'kaminari'
gem 'declarative_authorization'
gem "bourbon", "~> 1.4.0"
gem 'letter_opener', :group => :development
gem 'rails_admin'
gem 'sqlite3', :group => :development
gem 'toPinyin'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.0"
  gem 'coffee-rails', "~> 3.2.0"
  gem 'uglifier'
  #gem 'jquery-datatables-rails', :git => 'git://github.com/rweng/jquery-datatables-rails'
  gem 'jquery-ui-rails'
end
gem 'jquery-rails'
gem 'tinymce-rails',:git => 'git://github.com/spohlenz/tinymce-rails.git'
#gem "paperclip", "~> 2.0"
gem 'mongoid','2.4.1'
gem 'bson_ext', '1.5.2'
gem 'mongoid_fulltext','0.5.7'
gem 'mongoid_slug', '0.10.0'
gem 'cancan'
gem 'simple_enum',:git => 'git://github.com/lwe/simple_enum.git'
gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem "aws-sdk",            :require => "aws/s3"
gem 'thin'
gem 'mongoid_auto_increment'
gem 'best_in_place', github: 'bernat/best_in_place'
gem 'remotipart', '~> 1.0'

group :production do
  # gems specifically for Heroku go here
  gem "heroku"
  gem "pg"
end

gem "erb2haml", :group => :development
gem "faker"
# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
gem "mocha", :group => :test
