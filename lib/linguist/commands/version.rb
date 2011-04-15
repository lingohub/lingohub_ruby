module Linguist::Command
  class Version < Base
    def index
      display Linguist::Client.gem_version_string
    end
  end
end
