# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/toolbox'
require 'twitter'

module Cinch
  module Plugins
    # Cinch Plugin to post twitter statuses
    class TwitterWatch
      include Cinch::Plugin

      timer 15, method: :check_watched

      def initialize(*args)
        super
        @client = twitter_client
        @watched = build_watchers
      end

      def check_watched
        return unless @watched
        @watched.each { |w| check_for_tweet(w) }
      rescue Twitter::Error::NotFound
        debug 'You have set an invalid or protected user ' \
              'to watch, please correct this error'
      rescue Twitter::Error::TooManyRequests
        debug 'Trottled checking user; sleeping 60 seconds.'
        sleep 60
      end

      def check_for_tweet(w)
        # Just check the last tweet, if they are posting more than once
        # every timer tick we don't want to spam the channel.
        debug "Checking Tweets for #{w.nick} (#{w.tweet_cache.count} cached)"
        tweet = @client.user(w.nick).status
        status = w.tweet_unless_cached(tweet.id)
        Channel(w.channel).msg(tweet_text(w.nick, status)) unless status.nil?
      end

      def format_tweet(url)
        # Parse the url and get the relevant data
        user, status = parse_twitter_url(url)

        # Return blank if we didn't get a good user and status
        return if user.nil? || status.nil?

        tweet(user, status)
      end

      def tweet_text(user, status)
        # Scrub the tweet for returns so we don't have multilined responses.
        flat_status = status.gsub(/[\n]+/, ' ')
        "@#{user} tweeted \"#{flat_status}\""
      end

      private

      def parse_twitter_url(url)
        tweet_id = url[%r{statuse?s?/(\d+)/?}, 1]
        user     = url[%r{/?#?!?/([^\/]+)/statuse?s?}, 1]
        [user, Twitter.status(tweet_id).text]
      end

      def build_watchers
        watched = []
        config[:watchers].each_pair do |chan, users|
          users.each do |user|
            watcher = Cache.new(user, chan, @client)
            debug "#{watcher.init_cache}"
            watched << watcher
          end
        end
        watched
      end

      def twitter_client
        Twitter::REST::Client.new do |c|
          c.consumer_key =        config[:consumer_key]
          c.consumer_secret =     config[:consumer_secret]
          c.access_token =        config[:access_token]
          c.access_token_secret = config[:access_secret]
        end
      end
    end
  end
end
