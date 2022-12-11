RSpec.describe RbYoutubeDL::Options do
  let(:example_pair) { { parent_key: 'parent value' } }
  let(:banned_pair) { { banned_key: 'Outlaw Country! Whoo!' } }

  before do
    @options = RbYoutubeDL::Options.new
    @options.banned_keys.push :banned_key
  end

  describe '#initialize' do
    it 'should symbolize option keys' do
      @options.store['key'] = "value"
      @options.sanitize_keys!

      expect(@options.store).to eq({ key: 'value' })
    end

    it 'should accept a parent Options as a param' do
      parent = RbYoutubeDL::Options.new(parent_key: 'parent value')
      child = RbYoutubeDL::Options.new(parent)

      expect(parent.store).to eq(child.store)
    end

    it 'should accept a Hash as a param' do
      hash = { parent_key: 'parent value' }
      options = RbYoutubeDL::Options.new(hash)

      expect(options.store).to eq(hash)
    end
  end

  describe '#to_hash, #to_h' do
    before do
      @options.store[:key] = "value"
    end

    it 'should return a hash' do
      expect(@options.to_hash).to be_a(Hash)
    end

    it 'should be equal to store' do
      expect(@options.to_hash).to eq(@options.store)
    end

    it 'should not include banned keys' do
      @options.store.merge! banned_pair

      expect(@options.to_h.keys).to_not include(:banned_key)
    end
  end

  describe '#each_paramized' do
    it 'should properly paramize keys and not values' do
      @options.some_key = "some value"

      @options.each_paramized do |key, value|
        expect(key).to eq('some-key')
        expect(value).to eq('some value')
      end
    end
  end

  describe '#each_paramized_key' do
    it 'should properly paramize keys' do
      # TODO: Write a better test name
      @options.some_key = "some value"

      @options.each_paramized_key do |key, paramized_key|
        expect(key).to eq(:some_key)
        expect(paramized_key).to eq('some-key')
      end
    end
  end

  describe '#configure' do
    it 'should be able to use an explicit configuration block' do
      @options.configure do |c|
        c.get_operator = true
        c['get_index'] = true
      end

      expect(@options.store[:get_operator]).to be_truthy, "Actual: #{@options.store[:get_operator]}"
      expect(@options.store[:get_index]).to be_truthy, "Actual: #{@options.store[:get_index]}"
    end

    it 'should not override parent configuration' do
      opts = RbYoutubeDL::Options.new(parent: 'value')
      opts.configure do |c|
        c.child = 'vlaue'
      end

      expect(opts.store[:parent]).to eq('value')
      expect(opts.store[:child]).to eq('vlaue')
    end

    it 'should remove any banned keys automatically' do
      @options.configure do |c|
        c.parent_key = 'parent value'
        c.banned_key = 'nope'
      end

      expect(@options.store).to eq(example_pair)
    end
  end

  describe '#[], #[]==' do
    it 'should be able to use brackets' do
      @options[:mtn] = :dew

      expect(@options[:mtn]).to eq(:dew)
    end

    it 'should automatically symbolize keys' do
      @options.get_operator = true
      @options['get_index'] = true

      expected_keys = [:get_operator, :get_index]
      expect(@options.store.keys).to include(*expected_keys)
    end

    it 'should remove any banned keys automatically' do
      @options[:banned_key] = 'nope'

      expect(@options.store).to_not include(:banned_key)
    end

    it 'should not return any banned keys' do
      @options.store.merge! banned_pair

      expect(@options[:banned_key]).to be_nil
    end
  end

  describe '#with' do
    let(:addon_pair) { { secondary_key: 'secondary value' } }

    before do
      @options.store.merge! example_pair
    end

    it 'should merge @store and given hash' do
      expect(@options.with(addon_pair).to_h).to eq(example_pair.merge(addon_pair))
    end

    it 'should not affect @store directly' do
      @options.with(addon_pair)

      expect(@options.store).to eq(example_pair)
    end

    it 'should not include banned keys' do
      expect(@options.with(banned_pair).to_h).to_not include(:banned_key)
    end
  end

  describe '#method_missing' do
    it 'should be able to set options with method_missing' do
      @options.test = true

      expect(@options.store[:test]).to be_truthy
    end

    it 'should be able to retrieve options with method_missing' do
      @options.store[:walrus] = 'haswalrus'

      expect(@options.walrus).to eq('haswalrus')
    end

    it 'should remove any banned keys automatically' do
      @options.banned_key = 'nope'

      expect(@options.store).to_not include(:banned_key)
    end

    it 'should not return any banned keys' do
      @options.store.merge! banned_pair

      expect(@options.banned_key).to be_nil
    end
  end

  describe '#manipulate_keys!' do
    it 'should manipulate keys' do
      @options.some_key = 'value'
      @options.manipulate_keys! do |key|
        key.to_s.upcase
      end

      expect(@options.store).to eq({ 'SOME_KEY' => 'value' })
    end
  end

  describe '#sanitize_keys!' do
    it 'should convert hyphens to underscores in keys' do
      # See issue #9
      @options.store[:"hyphenated-key"] = 'value'
      @options.sanitize_keys!

      expect(@options.to_h).to eq({ hyphenated_key: 'value' })
    end
  end

  describe '#sanitize_keys' do
    it 'should not modify the original by calling sanitize_keys without bang' do
      @options.store['some-key'] = "some_value"

      expect(@options.sanitize_keys).not_to eq(@options)
    end

    it 'should return instance of Options when calling sanitize_keys' do
      @options.store['some-key'] = "some_value"

      expect(@options.sanitize_keys).to be_a(RbYoutubeDL::Options)
    end
  end

  describe '#banned?' do
    it 'should return true for a banned key' do
      expect(@options.banned?(:banned_key)).to be_truthy, "Key :banned_key was not banned"
    end

    it 'should return false for a not banned key' do
      expect(@options.banned?(:not_banned_key)).to be_falsey, "Key :not_banned_key was banned"
    end
  end
end
