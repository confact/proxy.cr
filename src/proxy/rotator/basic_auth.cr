class Proxy::Rotator::BasicAuth
  include HTTP::Handler

  @logins : Array(Array(String))

  def initialize(username : String, password : String)
    @logins = [[username, password]]
  end

  def initialize(@logins : Array(Array(String)))
  end

  def call(context)
    if context.request.headers.has_key?("Proxy-Authorization")
      _, enc = context.request.headers["Proxy-Authorization"].split
      username, password = Base64.decode_string(enc).split(":")
      if authorized?(username, password)
        context.request.headers.delete("Proxy-Authorization")
        return call_next(context)
      end
    end

    context.response.headers.add("Proxy-Authenticate", "Basic realm=\"hello\"")
    context.response.status_code = 407
    context.response.puts("")
  end

  private def authorized?(username, password)
    @logins.includes?([username, password])
  end
end
