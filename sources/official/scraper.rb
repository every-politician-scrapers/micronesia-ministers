#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      Name.new(
        full:     title.include?('President') ? content : title,
        prefixes: %w[The Honorable Hon. H.E. Ms. Dr.],
      ).short
    end

    field :position do
      title.include?('President') ? title : content
    end

    private

    def title
      noko.css('.sppb-addon-title').text.tidy
    end

    def content
      noko.css('.sppb-addon-content *').map(&:text).map(&:tidy).reject(&:empty?).uniq.join(", ")
    end
  end

  class Members
    def member_container
      noko.css('.sppb-column a[@href^=http]').xpath('ancestor::div[@class="sppb-column"]')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
