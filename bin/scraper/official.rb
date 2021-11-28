#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('.sppb-addon-title').text.tidy
    end

    def position
      noko.css('.sppb-addon-content *').map(&:text).map(&:tidy).reject(&:empty?).join(", ")
    end
  end

  class Members
    def member_container
      noko.xpath('.//div[@class="sppb-column"][.//img]')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
