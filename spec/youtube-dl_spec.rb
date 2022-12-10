RSpec.describe YoutubeDL do
  describe '::VERSION' do
    let(:version) { YoutubeDL::VERSION }

    it 'is a valid Rubygem version' do
      # "Malformed version number string #{version}"
      expect(Gem::Version.correct?(version)).to be_truthy
    end

    it 'is the correct format' do
      version_matcher = /\d+.\d+.\d+.\d{4}\.\d+\.\d+\.?\d+?/
      expect(version).to match(version_matcher)
    end
  end

  describe '.download' do
    before do
      clear_youtube_dl_cache
    end

    after do
      remove_downloaded_files
    end

    it 'should download videos without options' do
      YoutubeDL.download default_test_url
      expect(Dir.glob(default_test_glob).length).to eq(1)
    end

    it 'should download videos with options' do
      YoutubeDL.download default_test_url, output: default_test_filename, format: default_test_format
      expect(File.exist?(default_test_filename)).to be_truthy
    end

    it 'should download multiple videos without options' do
      YoutubeDL.download [default_test_url, default_test_url2]
      expect(Dir.glob(default_test_glob).length).to eq(2)
    end

    it 'should download multiple videos with options' do
      YoutubeDL.download [default_test_url, default_test_url2], output: 'test_%(title)s-%(id)s.%(ext)s'
      expect(Dir.glob('test_' + default_test_glob).length).to eq(2)
    end
  end

  describe '.get' do
    before do
      clear_youtube_dl_cache
    end

    after do
      remove_downloaded_files
    end

    it 'should download videos, exactly like .download' do
      YoutubeDL.get default_test_url
      expect(Dir.glob(default_test_glob).length).to eq(1)
    end
  end

  describe '.extractors' do
    before do
      @extractors = YoutubeDL.extractors
    end

    it 'should return an Array' do
      expect(@extractors).to be_a(Array)
    end

    it 'should include the youtube extractors' do
      expected_youtube_extractors = ["youtube", "youtube:favorites", "youtube:history", "youtube:playlist", "youtube:recommended", "youtube:search", "youtube:search:date", "youtube:subscriptions", "youtube:tab", "youtube:truncated_id", "youtube:truncated_url", "youtube:watchlater", "YoutubeYtBe", "YoutubeYtUser"]
      expect(@extractors).to include(*expected_youtube_extractors)
    end
  end

  describe '.binary_version' do
    before do
      @version = YoutubeDL.binary_version
    end

    it 'should return a string' do
      expect(@version).to be_a(String)
    end

    it 'should be a specific format with no newlines' do
      version_matcher = /\d+.\d+.\d+\z/
      expect(@version).to match(version_matcher)
    end
  end

  describe '.user_agent' do
    before do
      @user_agent = YoutubeDL.user_agent
    end

    it 'should return a string' do
      expect(@user_agent).to be_a(String)
    end

    it 'should be a specific format with no newlines' do
      user_agent_matcher = /Mozilla\/5\.0\s.*\).*\z/
      expect(@user_agent).to match(user_agent_matcher)
    end
  end
end
