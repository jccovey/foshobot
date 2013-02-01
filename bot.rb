#!/usr/bin/env ruby

require 'turntabler'

EMAIL = ENV['EMAIL']
PASSWORD =  ENV['PASS']
ROOM =  ENV['ROOM']

def dj_only_if_solo(client)
  if client.room.djs.length == 1
    client.room.become_dj
  elsif client.room.djs.length > 2 and client.user.dj?
    client.user.remove_as_dj
  end
end

Turntabler.run do
  client = Turntabler::Client.new(EMAIL, PASSWORD, :room => ROOM, :reconnect => true, :reconnect_wait => 60)

  dj_only_if_solo(client)

  client.on :dj_added do |user|
    dj_only_if_solo(client)
  end

  client.on :dj_removed do |user|
    dj_only_if_solo(client)
  end

  client.on :song_voted do |song|
    unless song.played_by == client.user
      if song.up_votes_count > 0
        song.enqueue :index => -1
      end
    end
  end
end