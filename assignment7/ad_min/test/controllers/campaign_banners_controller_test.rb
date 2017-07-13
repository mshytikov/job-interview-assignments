require 'test_helper'

class CampaignBannersControllerTest < ActionController::TestCase
  setup do
    @campaign_banner = campaign_banners(:one)
    @campaign = campaigns(:one)
    @banner = banners(:one)
  end

  test "should get index" do
    get :index, campaign_id: @campaign
    assert_response :success
    assert_not_nil assigns(:campaign_banners)
  end

  test "should get new" do
    get :new, campaign_id: @campaign
    assert_response :success
  end

  test "should create campaign_banner" do
    assert_difference('CampaignBanner.count') do
      post :create, campaign_id: @campaign, campaign_banner: { banner_id: banners(:two), weight: @campaign_banner.weight }
    end

    assert_redirected_to campaign_banner_path(@campaign, assigns(:campaign_banner))
  end

  test "should not create campaign_banner with the same banner_id" do
    assert_difference('CampaignBanner.count', 0) do
      post :create, campaign_id: @campaign, campaign_banner: { banner_id: @banner, weight: @campaign_banner.weight }
    end
  end

  test "should show campaign_banner" do
    get :show, id: @campaign_banner, campaign_id: @campaign
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_banner, campaign_id: @campaign
    assert_response :success
  end

  test "should update campaign_banner" do
    patch :update, id: @campaign_banner, campaign_id: @campaign, campaign_banner: { banner_id: @banner, weight: @campaign_banner.weight }
    assert_redirected_to campaign_banner_path(@campaign, assigns(:campaign_banner))
  end

  test "should destroy campaign_banner" do
    assert_difference('CampaignBanner.count', -1) do
      delete :destroy, id: @campaign_banner, campaign_id: @campaign
    end
    assert_redirected_to campaign_banners_path(@campaign)
  end
end
