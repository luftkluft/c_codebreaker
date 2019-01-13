class Rules
  RULES_PATH_ROUTE = '../rules/'.freeze
  RULES_PATH_NAME = 'rules'.freeze
  RULES_PATH_FORMAT = '.txt'.freeze
  RULES_PATH = RULES_PATH_ROUTE + RULES_PATH_NAME + RULES_PATH_FORMAT
  def load_rules
    File.exist?(RULES_PATH) ? File.open(RULES_PATH, 'r') : []
  end
end