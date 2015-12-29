require 'travis/flags'

module Travis
  class App
    attr_reader :flags

    def initialize
      @flags = Flags.new(:redis)
    end

    def run
      loop do
        puts [Time.now, flags.active?(:feature)].join(' ')
        sleep 1
      end
    end
  end
end

app = Travis::App.new
app.flags.define(:feature, expires: '2016-11-01', purpose: 'try a new feature')

app.run
