RSpec.describe YoutubeDL::Video do
  before do
    clear_youtube_dl_cache
    @video = YoutubeDL::Video.new default_test_url, format: default_test_format
  end

  after do
    remove_downloaded_files
  end

  describe '.download' do
    it 'should download videos without options' do
      YoutubeDL::Video.download default_test_url, format: default_test_format
      expect(Dir.glob(default_test_glob).length).to eq(1)
    end

    it 'should download videos with options' do
      YoutubeDL::Video.download default_test_url, output: default_test_filename, format: default_test_format
      expect(File.exist?(default_test_filename)).to be_truthy
    end

    it 'should return an instance of YoutubeDL::Video' do
      video = YoutubeDL::Video.download default_test_url, format: default_test_format
      expect(video).to be_a(YoutubeDL::Video)
    end
  end

  describe '.get' do
    it 'should download videos, exactly like .download' do
      YoutubeDL::Video.get default_test_url, format: default_test_format
      expect(Dir.glob(default_test_glob).length).to eq(1)
    end
  end

  describe '#initialize' do
    it 'should return an instance of YoutubeDL::Video' do
      expect(@video).to be_a(YoutubeDL::Video)
    end

    it 'should not download anything' do
      expect(Dir.glob(default_test_glob)).to be_empty
    end
  end

  describe '#download' do
    it 'should download the file' do
      expect(Dir.glob(default_test_glob).length).to eq(0)
      @video.download
      expect(Dir.glob(default_test_glob).length).to eq(1)
    end

    it 'should set model variables accordingly' do
      @video.download
      expect(Dir.glob(default_test_glob).first).to eq(@video.filename)
    end

    it 'should raise ArgumentError if url is nil' do
      expect { YoutubeDL::Video.new(nil).download }.to raise_error(ArgumentError)
    end

    it 'should raise ArgumentError if url is empty' do
      expect { YoutubeDL::Video.new('').download }.to raise_error(ArgumentError)
    end
  end

  describe '#filename' do
    before do
      @video.options.configure do |c|
        c.output = default_test_filename
      end
    end

    it 'should be able to get the filename from the output' do
      @video.download
      expect(@video.filename).to eq(default_test_filename)
    end

    it 'should be able to be predicted' do
      predicted_filename = @video.information[:_filename]
      @video.download
      expect(@video.filename).to eq(predicted_filename)
    end

    it 'should return predicted filename before download' do
      predicted_filename = @video.filename
      expect(@video.information[:_filename]).to eq(predicted_filename) # Sanity check
      @video.download
      expect(@video.filename).to eq(predicted_filename)
    end

    it 'should not return previously predicted filename after editing the options' do
      predicted_filename = @video.filename
      @video.configure do |c|
        c.output = "#{default_test_filename}.2"
      end
      @video.download
      expect(@video.filename).to_not eq(predicted_filename)
    end

    # Broken due to how YoutubeDL::Video handles the filename
    # In older versions it parsed the command output looking for the filename,
    # But in more recent versions it gets the information from --print-json therefore
    # youtube-dl is at fault for not returning the correct filename.
    it 'should give the correct filename when run through ffmpeg' do
      skip #if travis_ci?
      @video.configure do |c|
        c.output = 'nope-%(id)s.%(ext)s'
        c.extract_audio = true
        c.audio_format = 'mp3'
        c.get_filename = true
      end
      @video.download
      expect(@video.filename).to eq("nope-#{TEST_ID}.mp3")
    end
  end

  describe '#information' do
    before do
      @information = @video.information
    end

    it 'should be a Hash' do
      expect(@information).to be_a(Hash)
    end

    it 'should not be empty' do
      expect(@information).not_to be_empty
    end

    it 'does not output to stdout when get_filename is true' do
      skip

      @video.options.get_filename = true

      # Test will error out if JSON::ParserError is raised.
      expect { @video.download }.to_not output.to_stdout
    end

    it 'does not output to stderr when get_filename is true' do
      skip

      @video.options.get_filename = true

      # Test will error out if JSON::ParserError is raised.
      expect { @video.download }.to_not output.to_stderr
    end
  end

  describe '#method_missing' do
    it 'should pull values from @information' do
      expect(@video.information[:extractor]).to eq('youtube') # Sanity Check
      expect(@video.extractor).to eq('youtube')
    end

    it 'should return correct formats for things' do
      expect(@video.formats).to be_a(Array)
      expect(@video.subtitles).to be_a(Hash)
    end

    it 'should fail if a method does not exist' do
      expect { @video.i_dont_exist }.to raise_error(NoMethodError)
    end
  end
end
