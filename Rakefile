require 'bundler'; Bundler.require
require_relative 'lib/unsplash'

task :default do
  Unsplash.each do |link|
    unless Dir[filename = link.pathmap('downloads/%f.jpg')].any?
      File.write filename, Unsplash.download(link)
    end

    $stdout.putc '.'
    $stdout.flush
  end
end
