require "linguist/client"
require "linguist/rails3/railtie" if defined?(Rails)

module Linguist
  class << self
    attr_accessor :environments

    def configure
      yield self
    end
  end
end
