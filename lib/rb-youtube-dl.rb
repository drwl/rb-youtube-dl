require 'terrapin'
require 'json'
require 'ostruct'

require 'rb-youtube-dl/version'
require 'rb-youtube-dl/support'
require 'rb-youtube-dl/options'
require 'rb-youtube-dl/runner'
require 'rb-youtube-dl/video'

# Global RbYoutubeDL module. Contains some convenience methods and all of the business classes.
module RbYoutubeDL
  extend self
  extend Support

  # Downloads given array of URLs with any options passed
  #
  # @param urls [String, Array] URLs to download
  # @param options [Hash] Downloader options
  # @return [RbYoutubeDL::Video, Array] Video model or array of Video models
  def download(urls, options = {})
    if urls.is_a? Array
      urls.map { |url| RbYoutubeDL::Video.get(url, options) }
    else
      RbYoutubeDL::Video.get(urls, options) # Urls should be singular but oh well. url = urls. There. Go cry in a corner.
    end
  end

  alias_method :get, :download

  # Lists extractors
  #
  # @return [Array] list of extractors
  def extractors
    @extractors ||= terrapin_line('--list-extractors').run.split("\n")
  end

  # Returns youtube-dl's version
  #
  # @return [String] youtube-dl version
  def binary_version
    @binary_version ||= terrapin_line('--version').run.strip
  end

  # Returns user agent
  #
  # @return [String] user agent
  def user_agent
    @user_agent ||= terrapin_line('--dump-user-agent').run.strip
  end
end
