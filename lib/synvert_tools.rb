require 'synvert'

class SynvertTools
  def self.matching_code(code, str_rules)
    instance = Synvert::Rewriter::Instance.new '(tempfile)'
    instance.current_source = code
    node = Parser::CurrentRuby.parse code
    rules = eval("{#{str_rules}}")
    if node.match? instance, rules
      matching_node = node
    else
      node.recursive_children do |child_node|
        matching_node = child_node and break if child_node.match? instance, rules
      end
    end

    if matching_node
      matching_code = code
      matching_code.insert(matching_node.loc.expression.end_pos, "</span>")
      matching_code.insert(matching_node.loc.expression.begin_pos, "<span class='highlight'>")
      [:match, matching_code]
    else
      [:unmatch, code]
    end
  end

  def self.to_ast_node(code)
    Parser::CurrentRuby.parse(code)
  end
end
