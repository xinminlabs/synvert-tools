module SynvertToolsApp
  module Routes
    class Root < Base
      configure do
        set :views, 'app/views/root'
      end

      get '/' do
        slim :index
      end

      post '/play' do
        code = params[:code].presence
        snippet = params[:snippet].presence

        begin
          result = SynvertTools.convert_code(code, snippet)

          if result
            result = result.gsub(/\n/, '<br>')
            result = result.gsub(/( )/, '&nbsp;')
          end

          content_type :json
          { result: result }.to_json
        rescue Parser::SyntaxError
          status 500
          {}.to_json
        end
      end

      post '/convert' do
        code = params[:code].presence

        begin
          result = SynvertTools.to_ast_node(code).to_sexp

          if result
            result = result.gsub(/\n/, '<br>')
            result = result.gsub(/( )/, '&nbsp;')
          end

          content_type :json
          { result: result }.to_json
        rescue Parser::SyntaxError
          status 500
          {}.to_json
        end
      end

      post '/match' do
        code = params[:code].presence
        rule = params[:rule].presence

        begin
          matchings = SynvertTools.matching_code(code, rule) if code && rule

          if matchings
            matchings[1] = matchings[1].gsub(/\n/, '<br>')
            matchings[1] = matchings[1].gsub(/(  )/, '&nbsp;&nbsp;')
          end

          content_type :json
          { matchings: matchings || [] }.to_json
        rescue Parser::SyntaxError
          status 500
          {}.to_json
        end
      end
    end
  end
end
