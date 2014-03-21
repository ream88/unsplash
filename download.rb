require 'bundler'
Bundler.require

Tumblr.configure do |config|
  config.consumer_key    = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
end

limit = 20
tumblr = Tumblr::Client.new
blog = tumblr.posts('unsplash.com')


download = proc do |url|
  filename = File.basename(url)

  File.open "downloads/#{filename}", 'w' do |file|
    file << open(url).read
  end
end


posts = []

begin
  urls = tumblr.posts('unsplash.com', offset: offset ||= 0, limit: limit)['posts'].map do |post|
    post['photos'].first['original_size']['url']
  end

  posts = posts.concat(urls)
  offset += limit
end while posts.count < blog['total_posts']

posts.each &download
