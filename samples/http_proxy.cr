require "../src/proxy_rotator"
require "option_parser"

host = "127.0.0.1"
port = 3199

OptionParser.parse! do |opts|
  opts.on("-h HOST", "--host HOST", "define host to run server") do |opt|
    host = opt
  end

  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end

logins = [["test", "pass"], ["uniq", "1234"]]

server = Proxy::Rotator::Server.new(host, port, handlers: [
  HTTP::LogHandler.new,
  Proxy::Rotator::BasicAuth.new(logins)
])

address = server.bind_tcp port
puts "Listening on http://#{host}:#{port}"
puts "Use #{logins.join(",")} for authentication"
server.listen
