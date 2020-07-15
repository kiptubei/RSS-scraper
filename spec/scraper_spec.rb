# spec/scraper_spec.rb

require './lib/scraper'

describe Scraper do
  subject { Scraper.new }

  describe '#contains_word?' do
    it 'returns true if title contains word in array' do
      title = 'sri lanka blames over 1,000 coronavirus cases on 1 man. he wants to clear his name'
      words = %w[corona covid]
      expect(subject.contains_word?(title, words)).to eql(true)
    end

    it 'returns false if title does not contain a word in the search array' do
      title = 'sri lanka blames over 1,000 deaths on 1 man. he wants to clear his name'
      words = %w[corona covid]
      expect(subject.contains_word?(title, words)).to eql(false)
    end
  end

  describe '#get_parsed_page' do
    it 'returns a nokogiri formated Document with all the page data in it' do
      url = 'http://feeds.bbci.co.uk/news/world/rss.xml'
      expect(subject.get_parsed_page(url).class).to eql(Nokogiri::XML::Document)
    end
  end

  describe '#parse' do
    url = 'http://feeds.bbci.co.uk/news/world/rss.xml'
    words = %w[corona]

    it 'parsed returns a array of hashes when given url and keywords' do
      url = 'http://feeds.bbci.co.uk/news/world/rss.xml'
      expect(subject.parse(url, words).first.class).to eql(Hash)
    end
  end

  describe '#find_source' do
    it 'returns the name of a news site from which the feed is from' do
      url = 'http://feeds.bbci.co.uk/news/world/rss.xml'
      expect(subject.find_source(url)).to eql('bbci')
    end
  end

  describe '#write_results' do
    it 'if write is successful Returns the number of bytes written.' do
      news = {
        source: 'one',
        title: 'two',
        description: 'three',
        link: 'four',
        published: 'five'
      }
      expect(subject.write_results(news, 'test.txt').class).to eql(Integer)
    end
  end

  describe '#read_file' do
    it 'if read is successful Returns an Array of the each line in the file.' do
      expect(subject.read_file('source.txt').class).to eql(Array)
    end
  end
end
