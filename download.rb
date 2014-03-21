require 'bundler'
Bundler.require

Tumblr.configure do |config|
  config.consumer_key    = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
end

download = proc do |url|
  filename = File.basename(url)

  File.open "downloads/#{filename}", 'w' do |file|
    file << open(url).read
  end
end

tumblr = Tumblr::Client.new

urls = 0.step(tumblr.posts('unsplash.com')['total_posts'], limit = 20).flat_map do |offset|
  tumblr.posts('unsplash.com', offset: offset, limit: limit)['posts'].map do |post|
    post['photos'].first['original_size']['url']
  end
end

urls.each &download
