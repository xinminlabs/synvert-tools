require 'synvert/core'
require 'tempfile'

class SynvertTools
  def self.matching_code(code, str_rules)
    node = self.to_ast_node code
    rules = self.to_hash_rules str_rules

    matching_nodes = []

    if node.match? rules
      matching_nodes << node
    else
      node.recursive_children do |child_node|
        matching_nodes << child_node if child_node.match? rules
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

  def self.convert_code(code, snippet)
    file = Tempfile.new 'test'
    Synvert::Core::Configuration.instance.set(:path, '')
    Synvert::Core::Configuration.instance.set(:skip_files, [])
    begin
      file.write code
      file.rewind
      Synvert::Rewriter.new 'test', 'test' do
        within_file file.path do
          eval(snippet)
        end
      end
      Synvert::Rewriter.call 'test', 'test'
      File.read file.path
    rescue
      code
    ensure
      file.close
      file.unlink
    end
  end

  # type: 'send', message: 'create
  # =>
  # {"type": "send", "message": "create"}
  def self.to_hash_rules(str_rules)
    ActiveSupport::JSON.decode('{"' + str_rules.gsub(':', '":').gsub(/, ?/, ', "').gsub("'", '"') + '}')
  end
end
