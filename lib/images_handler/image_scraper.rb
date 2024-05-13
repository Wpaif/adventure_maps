# frozen_string_literal: true

require 'dotenv/load'
require 'byebug'
require 'nokogiri'
require 'net/http'

# Classe responsavel por lidar com a obteção das imagens dos mapas
class ImageScraper
  def initialize
    Dotenv.load
  end

  def self.agroup_links
    uri = URI.parse(ENV.fetch('LINK_MAPS', nil))
    return [] unless uri.is_a?(URI::HTTP)

    response = Net::HTTP.get_response(uri)

    return [] unless response.is_a?(Net::HTTPSuccess)

    Nokogiri::HTML(response.body).css('center > p a').map { |link| URI.join(uri, link['href'].to_s) }
  rescue StandardError => e
    puts "Erro ao obter os links: #{e.message}"
  end
end
