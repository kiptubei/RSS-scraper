# scraper.rb
require 'nokogiri'
require 'httparty'

class Scraper
  attr_accessor :news

  def initialize
    @news = []
  end

  # processing begins here
  def scraper
    words = find_search_terms
    urls = read_file('source.txt')
    urls.each do |url|
      parse(url, words)
    end
  end

  def get_parsed_page(url)
    unparsed_page = HTTParty.get(url).to_s
    parsed_page = Nokogiri::XML(unparsed_page)
    parsed_page
  end

  def parse(url, words)
    articles = get_parsed_page(url).css('item')
    articles.each do |article|
      txt = article.css('title').text
      next unless contains_word?(txt, words)

      data = write_parsed_data(article, url)
      write_results(data, 'results.txt')
      @news << data
    end
    @news
  end

  # returns source of article e.g bbc
  def find_source(url)
    lines = url.chomp
    st = lines.split(/[.]/) # use regex to identify decimal point '.' and split into array
    ans = st[1]
    ans
  end

  # get search terms from user returns array search
  def find_search_terms
    puts 'Enter search criteria e.g Corona+Covid+Pandemic:'
    print '>'
    search_text = gets.chomp
    search = search_text.split('+')
    search
  end

  # append search results to file results.txt
  def write_results(news, file_name)
    file_data = File.write("lib/#{file_name}",
                           "#{news[:source]}\n" \
                           "#{news[:title]}\n" \
                           "#{news[:description]}\n" \
                           "#{news[:link]}\n" \
                           "#{news[:published]}\n\n",
                           mode: 'a')
    file_data
  end

  # read urls's from file source.txt line by line
  def read_file(name)
    puts File.join(File.dirname(__FILE__), name.to_s)
    file = File.open(File.join(File.dirname(__FILE__), name.to_s))
    file_url = file.readlines.map(&:chomp)
    file_url
  end

  # returns true or false if title has the keywords being searched for
  def contains_word?(title, words)
    words.each do |word|
      if /#{word.downcase}/.match(title.downcase)
        puts word.downcase + ' -- ' + title.downcase
        return true
      end
    end
    false
  end

  private

  # write resulting filtered data into hash data
  def write_parsed_data(article, url)
    data = {
      title: article.css('title').text,
      description: article.css('description').text,
      link: article.css('link').text,
      published: article.css('pubDate').text,
      source: find_source(url)
    }
    data
  end
end
