require 'synvert'

class SynvertTools
  def self.matching_code(code, str_rules)
    instance = Synvert::Rewriter::Instance.new '(tempfile)'
    instance.current_source = code
    node = Parser::CurrentRuby.parse code
    rules = eval("{#{str_rules}}")

    matching_nodes = []

    if node.match? instance, rules
      matching_nodes << node
    else
      node.recursive_children do |child_node|
        matching_nodes << child_node if child_node.match? instance, rules
      end
    end

    matching_nodes.reverse.each do |matching_node|
      code.insert(matching_node.loc.expression.end_pos, "</span>")
      code.insert(matching_node.loc.expression.begin_pos, "<span class='highlight'>")
    end

    [matching_nodes.empty? ? :unmatch : :match, code]
  end

  def self.to_ast_node(code)
    Parser::CurrentRuby.parse(code)
  end
end
