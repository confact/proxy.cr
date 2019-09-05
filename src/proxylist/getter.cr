class Proxylist::Getter

  @file : String?

  @lines : Array(Array(String))?

  def initialize
    get_file
    set_lines
    puts "PROXY ROTATOR Loaded #{(lines || [String]).size} proxies"
  end

  def get_proxy : Array(String) | Nil
    get_random_proxy
  end

  def get_file
    ENV["PROXYLIST_PATH"] ||= "./proxylist.txt"
    raise Proxylist::Getter::Exception.new("Couldn't find file") unless File.exists?(ENV["PROXYLIST_PATH"])
    @file ||= File.read(ENV["PROXYLIST_PATH"])
  end

  def set_lines : Array(Array(String)) | Nil
    return @lines unless @lines.nil?
    get_file
    splitted_lines= (@file || "").split("\n")
    @lines = splitted_lines.map do |line|
      line.split(':')
    end.reject { |x| x.size < 4 }
  end

  def get_random_proxy : Array(String) | Nil
    set_lines
    return nil if @lines.nil?
    (@lines || [nil]).sample
  end

  def lines
    @lines
  end
end

class Proxylist::Getter::Exception < Exception

end
