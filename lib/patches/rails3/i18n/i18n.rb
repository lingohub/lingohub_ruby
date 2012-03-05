# -*- encoding : utf-8 -*-
require "stringex"

module I18n
  class << self
    alias :base_translate :translate
    alias :base_localize :localize

    def translate(key, options={ })
      result = base_translate(key, options)
      wysiwyt_enabled = options.has_key?(:wysiwyt) ? options.delete(:wysiwyt) : true
      if wysiwyt_enabled && enabled?
        result = wrap_with_wysiwyt(key, result)
        result.html_safe
      else
        result
      end
    end

    def localize(object, options = { })
      result = base_localize(object, options)
      wysiwyt_enabled = options.has_key?(:wysiwyt) ? options.delete(:wysiwyt) : true
      if wysiwyt_enabled && enabled?
        result = wrap_with_wysiwyt(object, result)
        result.html_safe
      else
        result
      end
    end

    alias :t :translate
    alias :l :localize

    private

    def enabled?
      Lingohub.environments.include?(current_env) rescue false
    end

    def current_env
      defined?(Rails) ? Rails.env.to_sym : nil
    end

    def wrap_with_wysiwyt(translation_title, translation_phrase)
      "<span data-translation_url=\"#{link_to_translation_phrase(translation_title)}\" >#{translation_phrase}</span>"
    end

    def link_to_translation_phrase(translation_title)
      username          = option_to_url(Lingohub.username)
      project           = option_to_url(Lingohub.project)
      translation_title = translation_title.to_s.to_url

      "#{Lingohub.protocol}://#{Lingohub.host}/#{username}/#{project}/translations/#{translation_title}/phrases/#{locale}"
    end

    def option_to_url(option)
      if option.nil?
        ""
      elsif Lingohub.default_value?(option)
        option
      else
        option.to_url
      end
    end
  end
end
