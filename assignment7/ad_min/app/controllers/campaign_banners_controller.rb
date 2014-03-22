class CampaignBannersController < ApplicationController
  # Allow CRUD only in contenxt of campaign
  before_action :set_campaign

  before_action :set_campaign_banner, only: [:show, :edit, :update, :destroy]


  # GET /campaign_banners
  # GET /campaign_banners.json
  def index
    @campaign_banners = @campaign.campaign_banners
  end

  # GET /campaign_banners/1
  # GET /campaign_banners/1.json
  def show
  end

  # GET /campaign_banners/new
  def new
    @campaign_banner = CampaignBanner.new
  end

  # GET /campaign_banners/1/edit
  def edit
  end

  # POST /campaign_banners
  # POST /campaign_banners.json
  def create
    @campaign_banner = CampaignBanner.new(campaign_banner_params)

    respond_to do |format|
      if @campaign_banner.save
        format.html { redirect_to campaign_banner_url(@campaign, @campaign_banner), notice: 'Campaign banner was successfully created.' }
        format.json { render action: 'show', status: :created, location: @campaign_banner }
      else
        format.html { render action: 'new' }
        format.json { render json: @campaign_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaign_banners/1
  # PATCH/PUT /campaign_banners/1.json
  def update
    respond_to do |format|
      if @campaign_banner.update(campaign_banner_params)
        format.html { redirect_to campaign_banner_url(@campaign, @campaign_banner), notice: 'Campaign banner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @campaign_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaign_banners/1
  # DELETE /campaign_banners/1.json
  def destroy
    @campaign_banner.destroy
    respond_to do |format|
      format.html { redirect_to campaign_banners_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign_banner
      @campaign_banner = CampaignBanner.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_banner_params
      permitted = params.require(:campaign_banner).permit(:banner_id, :weight)
      permitted.merge(campaign_id: @campaign.id)
    end
end
