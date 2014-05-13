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

def each_post
  return to_enum(__callee__) unless block_given?

  Tumblr.configure do |config|
    config.consumer_key    = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
  end

  tumblr = Tumblr::Client.new

  0.step(tumblr.posts('unsplash.com')['total_posts'], limit = 20).flat_map do |offset|
    tumblr.posts('unsplash.com', offset: offset, limit: limit)['posts'].each do |post|
      yield post['id'], post['link_url'] || post['image_permalink']
    end
  end
end

task :default do
  each_post do |id, link|
    unless Dir[(filename = "downloads/#{id}") + '*'].any?
      file, url = download(link)
      filename = url.pathmap("#{filename}%x").downcase

      File.write(filename, file.body)
    end

    $stdout.putc '.'
    $stdout.flush
  end
end
