describe RedisNotifier::Base do

  let(:redis) do
    redis = double(:redis)
    allow(redis).to receive(:config)
    redis
  end
  let(:db) { '0' }
  subject { RedisNotifier::Base.new(redis, db) }

  describe '#initialize' do
    let(:keyspace_config) { 'foo' }
    it 'calls redis config.' do
      expect(redis).to receive(:config).with(:set, 'notify-keyspace-events', keyspace_config)
      RedisNotifier::Base.new(redis, db, keyspace_config)
    end
  end

  describe '#build_channel_for' do
    let(:prefix) { 'foo' }
    context 'type is "event"' do
      it { expect(subject.build_channel_for(:event, prefix) ).to eq("__keyevent@#{db}__:#{prefix}") }
    end
    context 'type is "key"' do
      it { expect(subject.build_channel_for(:key, prefix) ).to eq("__keyspace@#{db}__:#{prefix}") }
    end
  end

  describe '#find_type_from' do
    it { expect(subject.find_type_from('__keyevent@0__:foo')).to eq(:event) }
    it { expect(subject.find_type_from('__keyspace@0__:foo')).to eq(:key) }
    it { expect(subject.find_type_from('foobar')).to be(nil) }
  end

end