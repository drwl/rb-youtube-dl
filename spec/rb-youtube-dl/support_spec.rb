require 'tmpdir'

RSpec.describe RbYoutubeDL::Support do
  TestKlass = Class.new do
    include RbYoutubeDL::Support

    def executable_path
      usable_executable_path_for 'youtube-dl'
    end
  end

  before do
    @klass = TestKlass.new
  end

  describe '#usable_executable_path' do
    it 'should detect system executable' do
      vendor_bin = File.join(Dir.pwd, 'vendor', 'bin', 'youtube-dl')
      Dir.mktmpdir do |tmpdir|
        FileUtils.cp vendor_bin, tmpdir

        old_path = ENV["PATH"]
        ENV["PATH"] = "#{tmpdir}:#{old_path}"

        usable_path = @klass.usable_executable_path_for('youtube-dl')
        expect(usable_path).to match("#{tmpdir}/youtube-dl")

        ENV["PATH"] = old_path
      end
    end

    it 'should not have a newline char in the executable_path' do
      matcher = /youtube-dl\z/
      expect(matcher).to match(@klass.executable_path)
    end
  end

  describe '#terrapin_line' do
    it 'should return a Terrapin::CommandLine instance' do
      expect(@klass.terrapin_line('')).to be_a(Terrapin::CommandLine)
    end

    it 'should be able to override the executable' do
      line = @klass.terrapin_line('hello', 'echo')
      expect(line.command).to eq("echo hello")
    end

    it 'should default to youtube-dl' do
      line = @klass.terrapin_line(@klass.quoted(default_test_url))
      expected = "youtube-dl \"#{default_test_url}\""
      expect(line.command).to include(expected)
    end
  end

  describe '#quoted' do
    it 'should add quotes' do
      expect(@klass.quoted(default_test_url)).to eq("\"#{default_test_url}\"")
    end
  end

  describe '#which' do
    it 'should find a proper executable' do
      expect(File.exists?(@klass.which('ls'))).to be_truthy
    end
  end
end
