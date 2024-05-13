# frozen_string_literal: true

require 'spec_helper'
require 'image_scraper'

RSpec.describe ImageScraper do
  describe '.agroup_links' do
    let(:fake_uri) { URI.parse('http://example.com') }
    let(:response_double) { instance_double(Net::HTTPResponse, is_a?: Net::HTTPSuccess) }

    context 'when the ENV variable is set' do
      before do
        allow(ENV).to receive(:fetch).with('LINK_MAPS', nil).and_return(fake_uri.to_s)

        allow(response_double).to receive(:body)
          .and_return('<center><p><a href="/link1">Link 1</a><a href="/link2">Link 2</a></p></center>')
        allow(Net::HTTP).to receive(:get_response).with(fake_uri).and_return(response_double)
      end

      it 'returns an array of links' do
        links = described_class.agroup_links.map(&:to_s)
        expect(links).to eq(['http://example.com/link1', 'http://example.com/link2'])
      end
    end

    context 'when the ENV variable is not set' do
      before do
        allow(URI).to receive(:parse).and_return(nil)
      end

      it 'returns an empty array' do
        allow(URI).to receive(:parse).and_return(nil)

        links = described_class.agroup_links
        expect(links).to eq([])
      end
    end
  end
end
