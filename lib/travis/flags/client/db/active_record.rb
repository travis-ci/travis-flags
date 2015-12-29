begin
  require 'active_record'
  require 'pg'
rescue LoadError
end

module Travis
  class Flags
    class Client
      class Db
        class ActiveRecord < Adapter
          register :active_record

          ERRORS     = [::ActiveRecord::ActiveRecordError]
          NOT_UNIQUE = [::ActiveRecord::RecordNotUnique, PG::UniqueViolation]

          def query(sql, *args)
            connection.select_values(sanitize(sql, *args))
          end
          alias all query

          def first(sql, *args)
            query("#{sql} LIMIT 1", *args).first
          end

          private

            def sanitize(*args)
              ::ActiveRecord::Base.send(:sanitize_sql_array, args)
            end

            def connection
              ::ActiveRecord::Base.connection
            end
        end
      end
    end
  end
end
