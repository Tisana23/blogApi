require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  
  describe 'GET /posts' do
    
    context 'without data in the DB' do
      before {get '/posts'}

      it 'should return empty' do
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end
    end

    context 'with data in the DB' do
      let!(:posts) { create_list(:post, 10, published: true) }
      #before {get '/posts'}

      it 'should return all the published posts' do
        get '/posts'
        payload = JSON.parse(response.body)
        expect(payload.size).to eq(posts.size)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET posts/post' do
    describe 'GET /posts/{post.id}' do
      let(:post) { create(:post, published: true) }

      it 'should return a post' do
        get "/posts/#{post.id}"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload['id']).to eq(post.id)
        expect(payload['title']).to eq(post.title)
        expect(payload['content']).to eq(post.content)
        expect(payload['published']).to eq(post.published)
        expect(payload['author']['name']).to eq(post.user.name)
        expect(payload['author']['email']).to eq(post.user.email)
        expect(payload['author']['id']).to eq(post.user.id)
        expect(response).to have_http_status(200)
      end
    end

    # it "should return 404 if post not exists" do
    #   get "/posts/0"
    #   expect(response).to have_http_status(404)
    # end
  end

  describe "POST /posts" do
    let!(:user) {create(:user)}

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          published: false,
          user_id: user.id
        }
      }
      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it 'should return error message on invalid post' do
      req_payload = {
        post: {
          content: 'content',
          published: false,
          user_id: user.id
        }
      }
      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /posts/{post.id}" do
    let!(:article) {create(:post)}

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          published: true
        }
      }
      # POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(article.id)
      expect(response).to have_http_status(:ok)
    end

    it 'should return error message on invalid post' do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          published: false
        }
      }
      # POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
    
  end

end

