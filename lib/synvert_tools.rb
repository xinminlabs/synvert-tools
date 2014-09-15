require 'synvert/core'
require 'tempfile'

class SynvertTools
  def self.matching_code(code, str_rules)
    node = self.to_ast_node code
    rules = eval("{#{str_rules}}")

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
      snippet.gsub!(/within_files? ['"].*['"] do/, "within_file '#{file.path}' do")
      Synvert::Rewriter.new 'test', 'test' do
        eval(snippet)
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
end
