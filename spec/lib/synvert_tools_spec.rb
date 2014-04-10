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
    it 'converts  code to ast node' do
      code = "post = FactoryGirl.create :post"
      node = Parser::CurrentRuby.parse(code)
      expect(SynvertTools.to_ast_node(code)).to eq node
    end
  end
end
