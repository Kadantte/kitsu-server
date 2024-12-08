# frozen_string_literal: true

RSpec.describe WithModerationScores do
  before do
    Temping.create(:test_content) do
      def self.name = 'TestContent'
      with_columns do |t|
        t.jsonb :moderation_scores
        t.string :foo
        t.timestamps
      end
    end
    TestContent.include(described_class)
  end

  describe '#update_moderation_scores' do
    let!(:record) do
      TestContent.create!(foo: 'bar')
    end

    it 'adds the passed scores' do
      record.update_moderation_scores(
        scores: { foo: 100 }
      )
      expect(record.reload.moderation_scores).to include('foo' => 100)
    end

    it 'keeps the existing scores' do
      record.update!(moderation_scores: { bar: 50 })
      record.update_moderation_scores(
        scores: { foo: 100 }
      )
      expect(record.reload.moderation_scores).to include('bar' => 50)
    end

    it 'touches the record' do
      Timecop.travel(5.minutes.from_now) do
        expect {
          record.update_moderation_scores(
            scores: { foo: 100 }
          )
        }.to(change { record.reload.updated_at })
      end
    end

    it 'updates other passed properties' do
      record.update_moderation_scores(
        scores: { foo: 100 },
        foo: 'baz'
      )
      expect(record.reload.foo).to eq('baz')
    end
  end
end
