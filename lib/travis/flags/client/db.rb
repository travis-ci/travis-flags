require 'travis/support/registry'

module Travis
  class Flags
    class Client
      class Db < Client
        register :db

        class Adapter < Struct.new(:opts)
          include Registry
        end

        QUERIES = {
          keys:   'SELECT key FROM flags WHERE key LIKE ?',
          select: 'SELECT value FROM flags WHERE key = ?',
          insert: 'INSERT INTO flags (key, value) VALUES (?, ?)',
          update: 'UPDATE flags SET value = ? WHERE key = ?',
          delete: 'DELETE FROM flags WHERE key = ?'
        }

        def get(key)
          first(:select, key)
        end

        def set(key, value)
          query(:insert, key, value)
        rescue *adapter.class::NOT_UNIQUE
          query(:update, value, key)
        end

        def del(key)
          query(:delete, key)
        end

        def keys(prefix)
          all(:keys, "#{prefix}%").compact
        end

        def errors
          adapter.class::ERRORS
        end

        private

          def first(query, *args)
            adapter.first(QUERIES[query], *args)
          end

          def all(query, *args)
            adapter.all(QUERIES[query], *args)
          end

          def query(query, *args)
            adapter.query(QUERIES[query], *args)
          end

          def adapter
            @adapter ||= Adapter[opts.delete(:adapter) || :active_record].new(opts)
          end
      end
    end
  end
end

require 'travis/flags/client/db/active_record'
require 'travis/flags/client/db/sequel'
