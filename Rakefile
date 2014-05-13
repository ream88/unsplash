require 'bundler'
Bundler.require

task :default do
  Tumblr.configure do |config|
    config.consumer_key    = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
  end

  tumblr = Tumblr::Client.new

  urls = 0.step(tumblr.posts('unsplash.com')['total_posts'], limit = 20).flat_map do |offset|
    tumblr.posts('unsplash.com', offset: offset, limit: limit)['posts'].map do |post|
      post['photos'].first['original_size']['url']
    end
  end

  urls.each do |url|
    File.write(url.pathmap('downloads/%f'), open(url).read)
  end
end
