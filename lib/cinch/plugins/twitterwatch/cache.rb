module Cinch::Plugins
  class TwitterWatch
    class Cache
      attr_accessor :nick, :channel, :tweet_cache, :client

      def initialize(nick, channel, client, tweets = {})
        @nick = nick
        @client = client
        @channel = channel
        @tweet_cache = tweets
      end

      def init_cache
        @client.search("from:#{@nick}").each do |tweet|
          cache_tweet(tweet.id)
        end
        "Cache: [#{@nick}]: #{@tweet_cache.count} tweets cached."
      #rescue Twitter::Error::NotFound
      #  debug "You have set an invalid or protected user (#{@nick}) to " +
      #        ' watch, please correct this error'
      end

      def tweet_unless_cached(tweet_id)
        return if @tweet_cache.key?(tweet_id)
        cache_tweet(tweet_id)
        @client.status(tweet_id).text
      end

      def cache_tweet(tweet_id)
        @tweet_cache[tweet_id.to_i] = true
        true
      end
    end
  end
end
