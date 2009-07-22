#!/usr/bin/ruby
require 'rubygems'
require 'findmyiphone'
require 'oauth'
require 'fireeagle'
require 'pp'

c = FireEagle::Client.new(YAML.load_file("fireeagle_keys.yml"))
i = YAML.load_file("iphone_credentials.yml")
f = FindMyIphone.new(i[:username], i[:password])
puts "Looking for your iphone..."
f.devices
puts "Requesting location from MobileMe..."
loc = f.locateMe
puts "Updating Fire Eagle..."
result = c.update(:lat => loc['latitude'], :lon => loc['longitude'])
puts "Fire Eagle said #{result.status}."
