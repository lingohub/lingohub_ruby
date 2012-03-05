require "bundler/setup"

require "rspec"
require "support/matchers"

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "../")
require "lib/lingohub"

RSpec.configure do |config|
  config.include NewGem::Spec::Matchers
end
