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

  describe "#save_banner" do
    let(:weights)    { "campaign:1:banners" }
    let(:banners)    { "campaign:1:weights" }
    let(:id)    { "10" }
    let(:url)    { "http://ad.serve.com" }
    let(:weight) { '30' }

    context "first banner in campaign" do
      it "should create set of keys" do
        expect { campaign.save_banner(id, url, weight) }.to change{ redis.dbsize }.by(4)
      end

      it "should increase the size of campaign" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.get("campaign:1:size")
        }.from(nil).to('1')
      end

      it "should create campaign weights key" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.hgetall("campaign:1:weights")
        }.from({}).to( { '0' => weight })
      end

      it "should create campaign banner key" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.hgetall("campaign:1:banners")
        }.from({}).to( { '0' => id })
      end

      it "should create banner key" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.hgetall("campaign:1:banner:10")
        }.from({}).to( {'index' => '0', 'url'=> url } )
      end
    end

    context "new banner in campaign" do
      before{ campaign.save_banner(id, url, weight) }

      it "should add new banner" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{ redis.dbsize }.by(1)
      end

      it "should increase the campaign size key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.get("campaign:1:size")
        }.from('1').to('2')
      end

      it "should create campaign weights key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.hgetall("campaign:1:weights")
        }.from({ '0' => weight }).to({'0' => weight, '1' => '40'})
      end

      it "should create campaign banners key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.hgetall("campaign:1:banners")
        }.from({ '0' => id }).to({'0' => id, '1' => '2'})
      end

      it "should create banner key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.hgetall("campaign:1:banner:2")
        }.from({}).to( {'index' => '1', 'url'=> 'url1' } )
      end
    end

    context "existing banner in campaign" do
      before{ campaign.save_banner(id, url, weight) }

      it "should not add new banner" do
        expect { campaign.save_banner(id, 'url1', '40') }.to_not change{ redis.dbsize }
      end

      it "should not increase the size of campaign" do
        expect { campaign.save_banner(id, 'url1', '40') }.to_not change{
          redis.get("campaign:1:size")
        }
      end

      it "should update campaign weights key" do
        expect { campaign.save_banner(id, 'url1', '40') }.to change{
          redis.hgetall("campaign:1:weights")
        }.from({ '0' => weight }).to({'0' => '40' })
      end

      it "should not update campaign banners key" do
        expect { campaign.save_banner(id, 'url1', '40') }.to_not change{
          redis.hgetall("campaign:1:banners")
        }
      end

      it "should update banner key" do
        expect { campaign.save_banner(id, 'url1', '40') }.to change{
          redis.hgetall("campaign:1:banner:10")
        }.from({'index' => '0', 'url'=> url }).to({'index' => '0', 'url'=> 'url1' })
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

      it "should delete empty campaign" do
        expect { campaign.delete }.to change{ redis.dbsize }.by(-1)
      end

      it "should delete non empty campaign" do
        campaign.save_banner('1', '1', '1')
        expect { campaign.delete }.to change{ redis.dbsize }.by(-5)
      end

    end
  end
end

