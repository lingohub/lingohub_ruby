require 'rails'

module Lingohub
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      Lingohub.environments ||= [:development]
      Lingohub.protocol ||= "https"
      Lingohub.host ||= "lingohub.com"
      Lingohub.username ||= ":username"
      Lingohub.project ||= ":project"
      Dir[File.join(File.dirname(__FILE__), "../../patches/**/*.rb")].each { |f| require f }
    end
  end
end
