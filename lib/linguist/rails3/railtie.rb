require 'rails'

module Linguist
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      Linguist.environments ||= [:development]
      Linguist.protocol ||= "https"
      Linguist.host ||= "app.lingui.st"
      Linguist.username ||= ":username"
      Linguist.project ||= ":project"
      Dir[File.join(File.dirname(__FILE__), "../../patches/**/*.rb")].each { |f| require f }
    end
  end
end