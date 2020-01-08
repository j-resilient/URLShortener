namespace :urlshortener do
    desc "Prunes old urls (that don't belong to premium members)"
    task prune_urls: :environment do
        n = ENV['n'].to_i
        puts "Pruning urls..."
        ShortenedUrl.prune(n)
    end
end