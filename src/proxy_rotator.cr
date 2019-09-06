require "./proxy/*"

module Proxy
  module Rotator
    VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
  end
end
