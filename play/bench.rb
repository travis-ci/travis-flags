require 'json'
require 'msgpack'
require 'benchmark'

hash = { name: :foo, user: [1, 2, 3, 4, 5, 6], repository: [1, 2, 3, 4, 5, 6], organization: [1, 2, 3, 4, 5, 6], expires: '2016-08-09', purpose: 'whatnot, one long sentence, whatnot, one long sentence, whatnot, one long sentence' }

bench = Benchmark.measure do
  1_000_000.times do
    str = JSON.dump(hash)
    JSON.parse(str)
  end
end
puts "json:   #{bench}"

bench = Benchmark.measure do
  1_000_000.times do
    str = MessagePack.pack(hash)
    MessagePack.unpack(str)
  end
end
puts "msgpack:#{bench}"
