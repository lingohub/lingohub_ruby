module Linguist::Command
  class Translations < Base

    def down
      if rails_environment?
        project.resources["en.yml"].download rails_locale_dir
      else
      end
    end

    def up
      if rails_environment?
      else

      end
    end

    private

    def rails_environment?
      true #TODO
    end

    def rails_locale_dir
      Dir.pwd + "/conf/locales"
    end

  end

end