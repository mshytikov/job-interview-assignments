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

    context "campaign does not exitst" do
      it "adds new campaign" do
        expect { campaign.save(40, 60) }.to change{ redis.dbsize }.by(1)
      end

      it "stores correct value" do
        expect { campaign.save(40, 60) }.to change{ 
          redis.hgetall(key)
        }.from({}).to(value)
      end
    end

    context "campaign already exitst" do
      before { campaign.save(40, 60) }
      let(:new_value) { {'random' => '60', 'weighted' => '40'} }

      it "does not create new campaign" do
        expect { campaign.save(60, 40) }.to_not change{ redis.dbsize }
      end

      it "updates the campaign" do
        expect { campaign.save(60, 40) }.to change{
          redis.hgetall(key)
        }.from(value).to(new_value)
      end
    end
  end


  describe "#save_banner" do
    let(:id)    { "10" }
    let(:url)    { "http://ad.serve.com" }
    let(:weight) { '30' }

    context "first banner in campaign" do
      it "creates set of keys" do
        expect { campaign.save_banner(id, url, weight) }.to change{ redis.dbsize }.by(4)
      end

      it "increases the size of campaign" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.get("campaign:1:size")
        }.from(nil).to('1')
      end

      it "creates campaign :weights key" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.hgetall("campaign:1:weights")
        }.from({}).to( { '0' => weight })
      end

      it "creates campaign :banners key" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.hgetall("campaign:1:banners")
        }.from({}).to( { '0' => id })
      end

      it "creates banner key" do
        expect { campaign.save_banner(id, url, weight) }.to change{
          redis.hgetall("campaign:1:banner:10")
        }.from({}).to( {'index' => '0', 'url'=> url } )
      end
    end

    context "new banner in campaign" do
      before{ campaign.save_banner(id, url, weight) }

      it "adds new banner" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{ redis.dbsize }.by(1)
      end

      it "increases the campaign :size key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.get("campaign:1:size")
        }.from('1').to('2')
      end

      it "creates campaign :weights key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.hgetall("campaign:1:weights")
        }.from({ '0' => weight }).to({'0' => weight, '1' => '40'})
      end

      it "creates campaign :banners key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.hgetall("campaign:1:banners")
        }.from({ '0' => id }).to({'0' => id, '1' => '2'})
      end

      it "creates banner key" do
        expect { campaign.save_banner('2', 'url1', '40') }.to change{
          redis.hgetall("campaign:1:banner:2")
        }.from({}).to( {'index' => '1', 'url'=> 'url1' } )
      end
    end

    context "existing banner in campaign" do
      before{ campaign.save_banner(id, url, weight) }

      it "does not add new banner" do
        expect { campaign.save_banner(id, 'url1', '40') }.to_not change{ redis.dbsize }
      end

      it "does not increase the size of campaign" do
        expect { campaign.save_banner(id, 'url1', '40') }.to_not change{
          redis.get("campaign:1:size")
        }
      end

      it "updates campaign :weights key" do
        expect { campaign.save_banner(id, 'url1', '40') }.to change{
          redis.hgetall("campaign:1:weights")
        }.from({ '0' => weight }).to({'0' => '40' })
      end

      it "does not update campaign :banners key" do
        expect { campaign.save_banner(id, 'url1', '40') }.to_not change{
          redis.hgetall("campaign:1:banners")
        }
      end

      it "updates banner key" do
        expect { campaign.save_banner(id, 'url1', '40') }.to change{
          redis.hgetall("campaign:1:banner:10")
        }.from({'index' => '0', 'url'=> url }).to({'index' => '0', 'url'=> 'url1' })
      end
    end
  end


  describe "#delete_banner" do
    let(:id)      { "10" }
    let(:id1)     { "20" }
    let(:url)     { "http://ad.serve.com" }
    let(:url1)     { "http://ad1.serve.com" }
    let(:weight)  { '30' }
    let(:weight1) { '40' }

    before{
      campaign.save_banner(id, url, weight)
      campaign.save_banner(id1, url1, weight1)
    }

    it "deletes banner_key" do
      expect { campaign.delete_banner(id) }.to change{ redis.dbsize }.by(-1)
    end

    it "does not decrease the size of campaign" do
      expect { campaign.delete_banner(id) }.to_not change{
        redis.get("campaign:1:size")
      }
    end

    it "deletes pair from campaign :weights key" do
      expect { campaign.delete_banner(id) }.to change{
        redis.hgetall("campaign:1:weights")
      }.from( { '0' => weight, '1' => weight1 }).to({'1' => weight1 })
    end

    it "deletes pair from campaign :banners key" do
      expect { campaign.delete_banner(id) }.to change{
        redis.hgetall("campaign:1:banners")
      }.from( { '0' => id, '1' => id1 }).to({'1' => id1 })
    end
  end


  describe '#delete' do
    let!(:another_campaign) { Campaign.new(2).save(0,0) }
    context "campaign does not exists" do
      it "does not change db" do
        expect { campaign.delete }.to_not change{ redis.dbsize }
      end
    end

    context "campaign exists" do
      before { campaign.save(1,1) }

      it "deletes empty campaign" do
        expect { campaign.delete }.to change{ redis.dbsize }.by(-1)
      end

      it "deletes non empty campaign" do
        campaign.save_banner('1', '1', '1')
        expect { campaign.delete }.to change{ redis.dbsize }.by(-5)
      end

    end
  end

  describe '#get_next_banner_url' do

    # This helper method returns exact value from redis
    # which is corresponding to input bit string
    def bitstr_value(bitstr)
      key = 'tmpbitstr'
      bitstr.each_char.with_index{|c, i|
        puts "="*20
        bit = (c == '0' ? 0 : 1)
        redis.setbit(key, i, bit)
      }
      value = redis.get(key)
      redis.del(key)
      return value
    end

    let(:user_id) { '1' }
    before { campaign.save(50,50) }


    context 'empty campaign' do
      it 'returns nil' do
        campaign.get_next_banner_url(user_id).should be_nil
      end
    end

    context 'non empty campaign' do
      let(:url) { 'http://test.com' }
      before{ campaign.save_banner('1', url, '1') }

      context 'new user' do
        it 'creates user key' do
          expect { campaign.get_next_banner_url(user_id) }.to change{ redis.dbsize }.by(1)
        end

        it 'sets bit for showed banner' do
          expect { campaign.get_next_banner_url(user_id) }.to change{
            redis.get('campaign:1:user:1')
          }.from(nil).to(bitstr_value("1"))
        end
      end

      it 'returns url' do
        campaign.get_next_banner_url(user_id).should == url
      end
    end

    context "full campaign" do

      it "should correctly return banner" do
        ids = (0..49)
        ids.each{ |i|
          campaign.save_banner(i.to_s, "http://#{i}.com", "#{i*10}")
        }
        campaign.size.should == 50

        returned_banners = ids.map{|i| campaign.get_next_banner_url(user_id) }
        returned_banners.size.should == 50
        returned_banners.uniq.size.should == 50

        campaign.get_next_banner_url.should be_nil

        campaign.save_banner(id.to_s, "http://50.com", 50)
        campaign.get_next_banner_url.should == 'http://50.com'
      end

    end

  end
end

