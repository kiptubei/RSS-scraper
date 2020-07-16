#!/usr/bin/env ruby
require_relative '../lib/scraper'

# scraper executable
class Main
  scraper = Scraper.new
  scraper.scraper
end

start = Main.new
start
