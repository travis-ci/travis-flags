require 'logger'
require 'stringio'

module Support
  module Logger
    def self.included(base)
      base.let(:io)     { StringIO.new }
      base.let(:logger) { ::Logger.new(io) }
      base.let(:stdout) { io.string }
    end
  end
end
