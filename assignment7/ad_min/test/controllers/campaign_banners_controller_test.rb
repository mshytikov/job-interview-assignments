require 'test_helper'

class CampaignBannersControllerTest < ActionController::TestCase
  setup do
    @campaign_banner = campaign_banners(:one)
    @campaign = campaigns(:one)
    @banner = banners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:campaign_banners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create campaign_banner" do
    assert_difference('CampaignBanner.count') do
      post :create, campaign_banner: { banner_id: @banner, campaign_id: @campaign, weight: @campaign_banner.weight }
    end

    assert_redirected_to campaign_banner_path(assigns(:campaign_banner))
  end

  test "should show campaign_banner" do
    get :show, id: @campaign_banner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @campaign_banner
    assert_response :success
  end

  test "should update campaign_banner" do
    patch :update, id: @campaign_banner, campaign_banner: { banner_id: @banner, campaign_id: @campaign, weight: @campaign_banner.weight }
    assert_redirected_to campaign_banner_path(assigns(:campaign_banner))
  end

  test "should destroy campaign_banner" do
    assert_difference('CampaignBanner.count', -1) do
      delete :destroy, id: @campaign_banner
    end

    assert_redirected_to campaign_banners_path
  end
end
