require "../src/proxy"

server = HTTP::Proxy::Server.new(8080, handlers: [
  HTTP::LogHandler.new
])

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
