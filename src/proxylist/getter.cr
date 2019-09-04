class Proxylist::Getter
  def self.get_proxy
    get_random_proxy
  end

  def self.get_file
    File.read("./proxylist.txt")
  end

  def self.get_random_proxy
    lines = get_file.split("\n")
    proxies = lines.map do |line|
      line.split(':')
    end.reject { |x| x.size < 4 }
    proxies.sample
  end
end
