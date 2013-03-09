#encoding: utf-8
require 'spec_helper'
require 'airport_scraper'
require 'yaml'

CA_TESTS = YAML.load_file(File.join(File.dirname(__FILE__), "ca_airports_tests.yml"))
US_TESTS = YAML.load_file(File.join(File.dirname(__FILE__), "us_airports_tests.yml"))
INTL_TESTS = YAML.load_file(File.join(File.dirname(__FILE__), "intl_airports_tests.yml"))
BAD_MATCHES = YAML.load_file(File.join(File.dirname(__FILE__), "bad_matches.yml"))

describe AirportScraper do
   
  context "new" do
    before :each do
      @scrape = AirportScraper::Scraper.new
    end
  
    it "should load the airports.yml file into @airports" do
      airports = @scrape.airports
      airports.should_not nil
      airports['JFK'].should_not nil
    end
  
    it "create an @code_match_regex to match 3-letter codes" do
      code_regex = @scrape.instance_variable_get("@code_match_regex")
      code_regex.should_not nil
      code_regex.should match('JFK')
      code_regex.should_not match('JFKX')
      code_regex.should_not match('jfk')
    end
    
    it "create an @airport_regex" do
      name_regex = @scrape.instance_variable_get("@airport_regex")
      name_regex.should_not nil
      name_regex.should match("Heathrow")
      name_regex.should_not match('HeathrowX')
    end
    
    it "create an @matcher_prefixes array" do
      by_priority = @scrape.instance_variable_get("@matcher_prefixes")
      by_priority.should_not nil
    end
    
    it "order @matcher_prefixes values in descending match_priority order" do
      # Check that PWM comes before PDX
      pref = @scrape.instance_variable_get("@matcher_prefixes")
      by_priority = pref[@scrape.prefix_from_match("Portland")]
      
      by_priority.should_not nil

      pdx = by_priority.detect {|x| x['code'] == 'PDX'}
      pwm = by_priority.detect {|x| x['code'] == 'PWM'}
      
      pdx_idx = by_priority.index(pdx)
      pwm_idx = by_priority.index(pwm)
      
      pdx_idx.should_not nil
      pwm_idx.should_not nil
      pwm_idx.should < pdx_idx
    end
  
  end 
  
#   context "possible_flight?" do
#     setup do
#       @scrape = AirportScraper.new
#     end
#     
#     ["on a flight to Rome", "flying to SFO", "just touched down in Vegas", "EWR to NYC", "EWR -> NYC"].each do |phrase|
#       should "return true for the phrase '#{phrase}'" do
#         assert @scrape.possible_flight?(phrase)
#       end
#     end
#   end
#   
#   context "extract_airports" do
#     setup do
#       @scrape = AirportScraper.new
#     end
#     
#     context "when there are no airports in the text" do
#       should "return an empty_array" do
#         assert_equal [], @scrape.extract_airports("Twas brillig and the slithy toves")
#       end
#     end
#     
#     context "Airport code tests" do
#       setup do
#         @scrape = AirportScraper.new
#       end
#       
#       should_eventually "be able to match the airport codes" do
#         @scrape.airports.each do |airport|
#           assert_contains @scrape.extract_airports("Just landed in #{airport['code']}."), airport
#         end
#       end
#     end
#     
#     context "Freeform name test" do
#       [US_TESTS, CA_TESTS, INTL_TESTS].each do |tests|
#         tests.keys.each do |code|
#           tests[code].each do |str|
#             should "return the airport #{code} for phrase '#{str}'" do
#               airport = @scrape.airport(code)
#               results = @scrape.extract_airports(str)
#               assert_contains results, airport, "Expected #{code}, returned #{results.map {|x| x['code']}.inspect }"
#             end
#           end
#         end
#       end
#     end
#     
#     context "Matchers" do
#       setup do
#         @scape = AirportScraper.new
#       end
#       
#       should "not have duplicate matchers for two airports" do
#         matchers = {}
#         airports = @scrape.airports
#         
#         airports.values.each do |airport|
#           airport['matchers'].each do |matcher|
#             if matchers[matcher].nil?
#               matchers[matcher] = airport
#             else
# #              if matchers[matcher]['code']['match_priority'] == airport['code']['match_priority']
#                 flunk "Matcher '#{matcher}' for more than one airport (#{matchers[matcher]['code']}, #{airport['code']}) at same priority"
# #              end
#             end
#           end
#         end
#       end
#       
#       should_eventually "not have shorter matchers for a name with a match_priority greater than a longer variant"
#     end
#     
#     context "Bad matches" do
#       BAD_MATCHES.each do |str|
#         should "not return any airports for phrase '#{str}'" do
#           results = @scrape.extract_airports(str)
#           assert_equal [], results, "Should not have matched anything, returned #{results.map {|x| x['code']}.inspect }"
#         end
#       end
#     end    
#   end
  
end
