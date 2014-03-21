require 'bundler'
Bundler.require

Tumblr.configure do |config|
  config.consumer_key    = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
end

limit = 20
tumblr = Tumblr::Client.new
blog = tumblr.posts('unsplash.com')


download = proc do |post|
  url = post['photos'].first['original_size']['url']
  filename = File.basename(url)

  File.open "downloads/#{filename}", 'w' do |file|
    file << open(url).read
  end
end


posts = []

begin
  posts = posts.concat(tumblr.posts('unsplash.com', offset: offset ||= 0, limit: limit)['posts'])
  offset += limit
end while posts.count < blog['total_posts']

posts.each &download
