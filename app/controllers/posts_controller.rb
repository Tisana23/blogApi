class PostsController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:update, :create]

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_server_error  
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json:{error: e.message}, status: :not_found    
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json:{error: e.message}, status: :unprocessable_entity    
  end

  # GET /posts
  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    render json: @posts.includes(:user), status: :ok
  end

  # GET /posts/{post.id}
  def show
    @post = Post.find(params[:id])
    if (@post.published) || (Current.user && @post.user_id == Current.user.id)
      render json: @post, status: :ok
    else
      render json: {error: 'Not Found'}, status: :not_found
    end
  end

  #POST /posts
  def create
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: :created
  end

  #PUT /posts/{post.id}
  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end

  # def authenticate_user! revisar concerns/secured.rb
  #   #verificar formato-- Bearer xxxx(token)
  #   token_regex = /Bearer (\w+)/
  #   #leer HEADER de auth
  #   headers = request.headers
  #   #verificar que sea valido
  #   if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
  #     token = headers['Authorization'].match(token_regex)[1]
  #     #debemos verificar que el token corresponda a un user
  #     #truthy falsy
  #     if (Current.user = User.find_by_auth_token(token))
  #       return
  #     end
  #   end
  #   render json: {error: 'Unauthorized'}, status: :unauthorized
  # end

end
