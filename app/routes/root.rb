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
        @code = params[:code]

        result = @code.present? ? SynvertTools.to_ast_node(@code).to_sexp : nil

        if result
          result = result.gsub(/\n/, '<br>')
          result = result.gsub(/( )/, '&nbsp;&nbsp;')
          p result
        end

        content_type :json
        { result: result }.to_json
      end

      post '/match' do
        @code = params[:code]
        @rules = params[:rules]
        
        @matchings = if @code.present? && @rules.present?
                       SynvertTools.matching_code(@code, @rules)
                     else
                       []
                     end

        content_type :json
        { matchings: @matchings }.to_json
      end
    end
  end
end
