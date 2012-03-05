# -*- encoding : utf-8 -*-require "rspec"
require "spec_helper"

require "i18n"
require "lib/patches/rails3/i18n/i18n.rb"

describe "I18n patch" do
  before :all do
    Lingohub.protocol = "http"
    Lingohub.host = "localhost:3000"
    Lingohub.username = "alisa"
    Lingohub.project = "odesk"

    I18n.locale = "de"
  end

  it "should not wrap with wysiwyt if current environment is not in lingohub options" do
    Lingohub.environments = [:test]
    I18n.should_receive(:current_env).and_return(:development)
    I18n.t("model.test.title").should == "translation missing: de.model.test.title"
  end

  it "should wrap with wysiwyt if current environment is in lingohub options" do
    Lingohub.environments = [:development]
    I18n.should_receive(:current_env).and_return(:development)
    I18n.t("model.test.title").should == "<span data-phrase_url=\"http://localhost:3000/alisa/odesk/model-dot-test-dot-title\" data-locale=\"de\" data-master-phrase=\"model.test.title\">translation missing: de.model.test.title</span>"
  end
end
