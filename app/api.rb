Dir["./app/apis/**/*.rb"].each { |f| require f }

class API < Grape::API
  format :json
  default_format :json

  # handle exceptions in a way that doesn't blow up the API; we'd rather actually get these back
  # as a response in a JSON block that tells us the API couldn't handle the request
  rescue_from :all do |e|
    API.logger.fatal "[FATAL] rescued from API #{e.class.name}: #{e.to_s} in #{e.backtrace.first}"
    rack_response({ message: "rescued from API error: #{e.class.name}", exception: e.to_s, detail: e.backtrace.to_s })
  end

  helpers do

    def logger
      API.logger
    end

    def render_custom(rabl_template, object, status, args={})
      args[:success] ||= true
      render_options = { format: 'hash' }
      render_options[:locals] = args[:locals] if args[:locals]
      data = Rabl::Renderer.new(rabl_template, object, render_options).render
      { success: args[:success], data: data }
    end

  end

  before do
    # sets the locale based on the incoming param, if provided, otherwise :en
    begin
      I18n.locale = params[:locale] ? params[:locale].downcase.to_sym  : :en
    rescue
      I18n.locale = :en
    end
  end


  resource 'helloworld' do
    desc "it works!"
    get "/" do
      MultiJson.dump({ status: 'OK', environment: Goliath::env })
    end
  end

  # NOTE: the mounts need to be *after* helpers and all that, or things get confused

  # if you remove/modify the next comment, the gen script won't be able to auto-add mount lines
  # -- ENDPOINT MOUNTS --

  # mount others:
  mount APIv1::Hello
end

