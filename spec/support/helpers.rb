require 'rake'

module Spec
  module Support
    module Helpers

      def default_test_id
        "gvdf5n-zI14"
      end

      def default_test_url
        "https://www.youtube.com/watch?feature=endscreen&v=gvdf5n-zI14"
      end

      def default_test_url2
        "https://www.youtube.com/watch?v=Mt0PUjh-nDM"
      end

      def default_test_filename
        "nope.avi.mp4"
      end

      def default_test_format
        "worst"
      end

      def default_test_glob
        "nope*"
      end

      def clear_youtube_dl_cache
        system("./vendor/bin/youtube-dl --rm-cache-dir")
      end

      def remove_downloaded_files
        Dir.glob("**/*nope*").each do |nope|
          File.delete(nope)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include(Spec::Support::Helpers)
end