module SynvertToolsApp
  module Routes
    class Root < Base 
      configure do
        set :views, 'app/views/root'
      end

      get '/' do
        slim :index 
      end
    end
  end
end
