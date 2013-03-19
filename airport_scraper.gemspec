# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "airport_scraper/version" 

Gem::Specification.new do |s|
  s.name      = 'airport_scraper'
  s.version   = AirportScraper::VERSION
  s.platform  = Gem::Platform::RUBY

  s.summary = "Code for scraping airports from freeform text"
  s.description = "A gem for extracting Airport mentions from short snippets of text. Just something I threw together as an experiment that’s turned into an interesting hobby project."

  s.authors   = ['Jacob Harris']
  s.email     = ['jharris@nytimes.com']
  s.homepage  = 'https://github.com/harrisj/airport_scraper'

  s.add_dependency 'geocoder'
  s.add_development_dependency 'rspec'
  
  # ensure the gem is built out of versioned files
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end