# proxy

A HTTP Proxy rotator written in Crystal inspired by Ruby's WEBrick::HTTPProxyServer

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  proxy_rotator:
    github: confact/proxy_rotator.cr
```

## Usage

```crystal
require "http/proxy"

server = HTTP::Proxy::Server.new(8080, [
  HTTP::LogHandler.new,
])

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
```

have a file of proxies named `proxylist.txt` in same folder as the sample file, like in the samples folder if you want to run that one. you can also change the path to the file by setting the env `PROXYLIST_PATH` to the path to the file.

The structure is:
```
ip:port:username:password
```
one proxy per line

## Development

* [x] Basic HTTP Proxy: GET, POST, PUT, DELETE support
* [x] Basic HTTP Proxy: OPTIONS support
* [X] HTTPS Proxy: CONNECT support
* [x] Make context.request & context.response writable
* [x] Basic (Proxy) Authorization support
* [ ] MITM HTTPS Proxy

## Contributing

1. Fork it ( https://github.com/bbtfr/proxy/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [bbtfr](https://github.com/bbtfr) Theo Li - creator, maintainer
- [mamantoha](https://github.com/mamantoha) Anton Maminov - Contributor
- [confact](https://github.com/confact) Håkan Nylén - proxy rotator maintainer
