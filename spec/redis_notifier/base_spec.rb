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
    context 'type is "events"' do
      it { expect(subject.build_channel_for(:events, prefix) ).to eq("__keyevent@#{db}__:#{prefix}") }
    end
    context 'type is "keys"' do
      it { expect(subject.build_channel_for(:keys, prefix) ).to eq("__keyspace@#{db}__:#{prefix}") }
    end
  end

  describe '#find_type_from' do
    it { expect(subject.find_type_from('__keyevent@0__:foo')).to eq(:events) }
    it { expect(subject.find_type_from('__keyspace@0__:foo')).to eq(:keys) }
    it { expect(subject.find_type_from('foobar')).to be(nil) }
  end

end