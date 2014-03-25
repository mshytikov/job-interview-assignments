require 'spec_helper' 

describe Campaign do 
  let(:redis) { Redis.current }

  subject(:campaign) { Campaign.new('1') }

  describe '.new(id)' do
    it { should respond_to(:id) }
    its(:id) { should == '1' }
  end

  describe '#save' do
    let(:key)      { "campaign:1:ratio" }
    let(:value)    { {'random' => '40', 'weighted' => '60'} }

    context "compaign does not exitst" do
      it "should add new campaign" do
        expect { campaign.save(40, 60) }.to change{ redis.dbsize }.by(1)
      end

      it "should store correct value" do
        expect { campaign.save(40, 60) }.to change{ 
          redis.hgetall(key)
        }.from({}).to(value)
      end
    end

    context "compaign already exitst" do
      before { campaign.save(40, 60) }
      let(:new_value) { {'random' => '60', 'weighted' => '40'} }

      it "should not create new campaign" do
        expect { campaign.save(60, 40) }.to_not change{ redis.dbsize }
      end

      it "should update the campaign" do
        expect { campaign.save(60, 40) }.to change{ 
          redis.hgetall(key)
        }.from(value).to(new_value)
      end
    end

  end


  describe '#delete' do
    let!(:another_campaign) { Campaign.new(2).save(0,0) }
    context "compaign does not exitst" do
      it "should not change db" do
        expect { campaign.delete }.to_not change{ redis.dbsize }
      end
    end

    context "compaign exists" do
      before { campaign.save(1,1) }

      it "should delete campaign" do
        expect { campaign.delete }.to change{ redis.dbsize }.by(-1)
      end
    end
  end

end

