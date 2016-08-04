class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show]

  def index
    @articles = policy_scope(Article)
  end


  def show
    authorize @article
    @article.record_page_view
    @comments = @article.comments
    load_gon
  end


  def new
    @article = Article.new
    authorize @article
  end


  def edit
    authorize @article
    load_gon
  end


  def create
    @article = current_participant.articles.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end


  def update
    authorize(current_participant,@article)
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    authorize @article
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end


  private
    def set_article
      @article = Article.find(params[:id])
      authorize @article
    end


    def article_params
      params.require(:article).permit(:article, :user_id, :published, :category, :summary,
                    article_sections_attributes: [:id, :article_id, :seq, :icon, :section, :description_markdown ],
                    image_attributes: [:id, :image, :_destroy ])
    end
end
