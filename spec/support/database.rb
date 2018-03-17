ENV.delete('DATABASE_URL')

require 'active_record'
require 'active_support/concern'
require 'logger'
require 'database_cleaner'

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.logger = Logger.new('log/db.test.log')
ActiveRecord::Base.configurations = { 'test' => { adapter: 'postgresql', database: 'travis_flags_test' } }
ActiveRecord::Base.establish_connection(:test)

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :truncation

module Support
  module Database
    extend ActiveSupport::Concern

    included do
      before { DatabaseCleaner.start }
      after  { DatabaseCleaner.clean }
    end
  end
end
