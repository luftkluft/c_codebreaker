# require 'pry'

class Rules
  RULES_PATH_ROUTE = 'lib/rules/'.freeze
  RULES_PATH_NAME = 'rules'.freeze
  RULES_PATH_FORMAT = '.txt'.freeze
  RULES_PATH = RULES_PATH_ROUTE + RULES_PATH_NAME + RULES_PATH_FORMAT
  def load_rules
    test = File.exist?(RULES_PATH)
    File.exist?(RULES_PATH) ? File.open(RULES_PATH, 'r') : []
    # binding.pry
  end
end