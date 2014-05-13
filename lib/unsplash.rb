module Unsplash
  Tumblr.configure do |config|
    config.consumer_key    = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
  end

  def self.download(url, limit = 10)
    raise Net::HTTPTemporaryRedirect if limit == 0

    case response = Net::HTTP.get_response(URI.parse(URI.encode(url.to_s)))
    when Net::HTTPSuccess
      response.body
    when Net::HTTPRedirection
      download(response['location'], limit - 1)
    end
  end

  def self.each
    return to_enum(__callee__) unless block_given?

    base_uri = 'unsplash.com'
    tumblr = Tumblr::Client.new

    0.step(tumblr.posts(base_uri)['total_posts'], limit = 20).each do |offset|
      tumblr.posts(base_uri, offset: offset, limit: limit)['posts'].each do |post|
        yield post['link_url'] || post['image_permalink']
      end
    end
  end
end
