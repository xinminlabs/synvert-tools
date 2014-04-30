module SynvertToolsApp
  module Routes
    class Root < Base 
      configure do
        set :views, 'app/views/root'
      end

      get '/' do
        slim :index 
      end

      post '/convert' do
        code = params[:code].presence

        result = SynvertTools.to_ast_node(code).to_sexp

        if result
          result = result.gsub(/\n/, '<br>')
          result = result.gsub(/( )/, '&nbsp;&nbsp;')
        end

        content_type :json
        { result: result }.to_json
      end

      post '/match' do
        code = params[:code].presence
        rule = params[:rule].presence
        
        matchings = SynvertTools.matching_code(code, rule) if code && rule

        if matchings
          matchings[1] = matchings[1].gsub(/\n/, '<br>')
          matchings[1] = matchings[1].gsub(/(  )/, '&nbsp;&nbsp;&nbsp;&nbsp;')
        end

        content_type :json
        { matchings: matchings || [] }.to_json
      end
    end
  end
end
