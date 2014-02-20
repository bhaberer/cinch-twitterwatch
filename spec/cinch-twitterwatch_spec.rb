# -*- coding: utf-8 -*-
require 'cinch'
require 'spec_helper'
describe Cinch::Plugins::TwitterWatch do
  include Cinch::Test

  before(:all) do
    @bot = make_bot(Cinch::Plugins::TwitterWatch,
                    { filename:        '/dev/null',
                      watchers:        { '#foo' => ['weirdo513'] },
                      consumer_key:    ENV['CONSUMER_KEY'],
                      consumer_secret: ENV['CONSUMER_SECRET'],
                      oauth_token:     ENV['OAUTH_TOKEN'],
                      oauth_secret:    ENV['OAUTH_SECRET'] })
  end

  describe "Watchers" do
    # FIXME: cinch-test does not allow timers to function
    it 'should not post tweets that already existed when the bot was started' do
      sleep 20
      get_replies(make_message(@bot, 'https://twitter.com/weirdo513/status/344186643609174016',
                               { channel: '#foo', nick: 'bar' }))
    end
  end
end

