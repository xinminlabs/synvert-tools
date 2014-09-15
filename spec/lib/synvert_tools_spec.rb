require 'spec_helper'

describe SynvertTools do
  describe '.matching_code' do
    it 'matches with highlight code' do
      code = "post = FactoryGirl.create :post"
      rules = "type: 'send', receiver: 'FactoryGirl', message: 'create'"
      matching_code = "post = <span class='highlight'>FactoryGirl.create :post</span>"
      expect(SynvertTools.matching_code(code, rules)).to eq [:match, matching_code]
    end

    it 'does not match' do
      code = "post = FactoryGirl.create :post"
      rules = "type: 'send', receiver: 'FactoryGirl', message: 'build'"
      matching_code = "post = FactoryGirl.create :post"
      expect(SynvertTools.matching_code(code, rules)).to eq [:unmatch, matching_code]
    end
  end

  describe '.to_ast_node' do
    it 'converts code to ast node' do
      code = "post = FactoryGirl.create :post"
      node = Parser::CurrentRuby.parse(code)
      expect(SynvertTools.to_ast_node(code)).to eq node
    end
  end

  describe '.convert_code' do
    it 'converts code by snippet' do
      code = "it 'test post' do\n  post = FactoryGirl.create(:post)\nend"
      snippet =<<-EOC
within_files '*.rb' do
  with_node type: 'send', receiver: 'FactoryGirl', message: 'create' do
    replace_with 'create({{arguments}})'
  end
end
EOC
      result = "it 'test post' do\n  post = create(:post)\nend"
      expect(SynvertTools.convert_code(code, snippet)).to eq result
    end
  end
end
