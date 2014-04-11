module SynvertToolsApp
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        disable :static

        set :slim, escape_html: true,
                   layout_options: {views: 'app/views/layouts'}

        enable :use_code
      end

      register Extensions::Assets
      helpers Helpers
      helpers Sinatra::ContentFor
    end
  end
end
