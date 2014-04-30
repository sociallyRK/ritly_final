class UrlsController < ApplicationController
  def new
    @url = Url.new
  end

  def create
    @url = Url.new
    @url.link = safe_url[:link]
    @url.random_string = SecureRandom.urlsafe_base64(5)
    @url.save
    redirect_to url_path(@url)
  end

  def index
    @url= Url.all
  end

  def show
    @url = Url.find(params[:id])
    @full_path = "#{request.protocol}#{request.host_with_port}/#{@url.random_string}"
    @api_link = "http://api.webthumbnail.org?width=500&height=400&screen=1024&url=" + @url.link

  end

  def edit
    @url = Url.find(params[:id])
  end

  def update
    @url = Url.find(params[:id])
    @url.update url_params
    redirect_to url_path(@url)
  end

  def destroy
    Url.find(params[:id]).destroy
    redirect_to urls_path
  end

  def go
    @url = Url.where(random_string: params[:random_string]).first
    @url.visit = @url.visit + 1
    @url.save
    redirect_to @url.link, alert: "We're moving somewhere!"
  end
  
  def redirector
    @url = Url.find_by random_string: params[:code]
    if @url
      redirect_to @url.link
    else
      redirect_to root_path
    end
  end

  def preview
    @url = Url.find_by random_string: params[:code]
    unless @url
      redirect_to root_path
    end
  end

  private
    def safe_url
      params.require(:url).permit(:link)
    end
end
