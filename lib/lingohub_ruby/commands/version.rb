module Lingohub::Command
  class Version < Base
    def index
      display Lingohub::Client.gem_version_string
    end
  end
end
