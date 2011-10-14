# -*- encoding : utf-8 -*-
require "stringex"

module I18n
  class << self
    alias :old_translate :translate

    def translate(*args)
      result = old_translate(args)
      result = wrap_with_wysiwyt(args.dup.shift, result) if enabled?
      result
    end

    alias :t :translate

    private

    def enabled?
      Linguist.environments.include?(current_env) rescue false
    end

    def current_env
      defined?(Rails) ? Rails.env.to_sym : nil
    end

    def wrap_with_wysiwyt(translation_title, translation_phrase)
      "<span data-phrase_url=\"#{link_to_translation(translation_title)}\" data-locale=\"#{locale}\" data-master-phrase=\"#{translation_title}\">#{translation_phrase}</span>"
    end

    def link_to_translation(translation_title)
      username = option_to_url(Linguist.username)
      project = option_to_url(Linguist.project)
      translation_title = translation_title.to_url

      "#{Linguist.protocol}://#{Linguist.host}/#{username}/#{project}/#{translation_title}"
    end

    def option_to_url(option)
      if option.nil?
        ""
      elsif Linguist.default_value?(option)
        option
      else
        option.to_url
      end
    end
  end
end