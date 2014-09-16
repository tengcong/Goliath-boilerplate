class APIv1
  class Hello < Grape::API
    version 'v1', using: :path
    format :json

    resource 'hello' do

      get '/test' do
        Hi.create name: 'test'
        hi = Hi.last
        hi
      end

      get "/" do
        @his = Hi.desc('created_at')
        render_custom "api_v1/hello/index", @his, 200
      end

      get "/:id" do
        render_custom "api_v1/hello/show", params[:id], 200
      end

      post '/create' do
        if hi = Hi.create(name: params[:name])
          {success: true, data: hi, count: Hi.count}
        else
          {success: false}
        end
      end
    end
  end
end
