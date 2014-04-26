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
