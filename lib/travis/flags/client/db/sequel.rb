begin
  require 'sequel'
rescue LoadError
end

module Travis
  class Flags
    class Client
      class Db
        class Sequel < Adapter
          register :sequel

          ERRORS     = [::Sequel::Error]
          NOT_UNIQUE = [::Sequel::UniqueConstraintViolation, PG::UniqueViolation]

          def query(sql, *args)
            connection.fetch(sql, *args).to_a
          end

          def all(sql, *args)
            query(sql, *args).map(&:values).flatten
          end

          def first(sql, *args)
            all("#{sql} LIMIT 1", *args).first
          end

          private

            def connection
              opts[:connection] || raise('Need to pass in a Sequel connection')
            end
        end
      end
    end
  end
end
