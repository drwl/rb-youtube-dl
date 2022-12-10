RSpec.describe YoutubeDL::Runner do
  before do
    clear_youtube_dl_cache
    @runner = YoutubeDL::Runner.new(default_test_url)
  end

  after do
    remove_downloaded_files
  end

  describe '#initialize' do
    it 'should take options as a hash yet still have configuration blocks work' do
      r = YoutubeDL::Runner.new(default_test_url, { some_key: 'some value' })
      r.options.configure do |c|
        c.another_key = 'another_value'
      end

      expected_to_be_included = ["--some-key", "--another-key"]

      expect(r.to_command).to include(*expected_to_be_included)
    end
  end

  describe '#executable_path' do
    it 'should set executable path automatically' do
      matcher = /youtube-dl/
      expect(matcher).to match(@runner.executable_path)
    end

    it 'should not have a newline char in the executable_path' do
      matcher = /youtube-dl\z/
      expect(matcher).to match(@runner.executable_path)
    end
  end

  describe '#backend_runner=, #backend_runner' do
    it 'should set terrapin runner' do
      @runner.backend_runner = Terrapin::CommandLine::BackticksRunner.new
      expect(@runner.backend_runner).to be_a(Terrapin::CommandLine::BackticksRunner)

      @runner.backend_runner = Terrapin::CommandLine::PopenRunner.new
      expect(@runner.backend_runner).to be_a(Terrapin::CommandLine::PopenRunner)
    end
  end

  describe '#to_command' do
    it 'should parse key-values from options' do
      @runner.options.some_key = "a value"

      expect(@runner.to_command.match(/--some-key\s.*a value.*/)).to_not be_nil
    end

    it 'should handle true boolean values' do
      @runner.options.truthy_value = true

      matcher = /youtube-dl .*--truthy-value\s--|\"http.*/
      expect(matcher).to match(@runner.to_command)
    end

    it 'should handle false boolean values' do
      @runner.options.false_value = false

      matcher = /youtube-dl .*--no-false-value\s--|\"http.*/
      expect(matcher).to match(@runner.to_command)
    end

    it 'should not have newline char in to_command' do
      matcher = /youtube-dl\s/

      expect(matcher).to match(@runner.to_command)
    end
  end

  describe '#run' do
    it 'should run commands' do
      @runner.options.output = default_test_filename
      @runner.options.format = default_test_format
      @runner.run
      expect(File.exists?(default_test_filename)).to be_truthy
    end
  end

  describe '#configure' do
    it 'should update configuration options' do
      @runner.configure do |c|
        c.output = default_test_filename
      end

      expect(@runner.options.output).to eq(default_test_filename)
    end
  end
end
