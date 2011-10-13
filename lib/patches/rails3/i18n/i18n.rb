# -*- encoding : utf-8 -*-
module I18n
  class << self
    alias :old_translate :translate

    def translate(*args)
      result = old_translate(args)
      result = wrap_with_wysiwyt(args.dup.shift, result) if Linguist.environments.include? Rails.env.to_sym
      result
    end

    alias :t :translate

    private

    def wrap_with_wysiwyt(key, phrase)
      "<span data-phrase_url=\"https://app.lingui.st/hjuskewycz/linguist/this-is-a-test\" data-locale=\"#{locale}\" data-master_phrase=\"#{key}\">#{phrase}</span>"
    end
  end
end