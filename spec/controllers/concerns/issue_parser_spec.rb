require 'rails_helper'

RSpec.describe IssueParser do
  subject(:parser) { Class.new{ include IssueParser }.new }
end
