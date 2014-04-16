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

        @nodes = @code.present? ? SynvertTools.to_ast_node(@code).to_s : nil

        content_type :json
        { nodes: @nodes }.to_json
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
