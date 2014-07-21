source 'https://rubygems.org'

gem 'rails', '4.1.1'
gem 'pg'
gem 'jquery-rails'
gem 'less-rails-bootstrap'
gem 'bootstrap_form' # https://github.com/bootstrap-ruby/rails-bootstrap-forms
gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'slim-rails' # HAML-like markup language. Faster than HAML. Supports streaming.
gem 'chronic' # Natural language date parser

group :development do
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'puma' # Use Puma as the development server, for fun, cause puma is interesting
  gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
  gem 'therubyracer' # Required by less
  gem 'guard-minitest'
end

group :development, :test do
  gem 'pry'
  gem 'pry-debugger'
  gem 'fabrication'
  gem 'minitest-rails'
  gem 'minitest-rails-capybara' # Use with: bin/rails generate minitest:feature CanAccessHome --spec
  gem 'mocha' # delicious mocks and stubs
  gem 'database_cleaner'
  gem 'mechanize' # used by scraper to make web requests
  gem 'timecop' # time freezing gem
  gem 'vcr'     # record web requests for scraper tests
  gem 'fakeweb' # used by vcr
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

