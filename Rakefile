require 'bundler'
Bundler.require

def download(url, limit = 10)
  raise Net::HTTPTemporaryRedirect if limit == 0

  case response = Net::HTTP.get_response(URI.parse(URI.encode(url.to_s)))
  when Net::HTTPSuccess
    [response, url]
  when Net::HTTPRedirection
    download(response['location'], limit - 1)
  end
end

task :default do
  Tumblr.configure do |config|
    config.consumer_key    = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
  end

  tumblr = Tumblr::Client.new

  urls = 0.step(tumblr.posts('unsplash.com')['total_posts'], limit = 20).flat_map do |offset|
    tumblr.posts('unsplash.com', offset: offset, limit: limit)['posts'].each do |post|
      file, url = download(post['link_url'])
      filename = url.pathmap("downloads/#{post['post_url'].pathmap('%f')}%x").downcase

      File.write(filename, file.body)
    end
  end
end
