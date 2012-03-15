require 'spec_helper'

describe Lingohub::Models::Project do

  describe '#initialize' do

    subject { projects[title] }

    let(:projects)           { Lingohub::Spec.projects                 }
    let(:owner)              { Lingohub::Spec.credentials[:username]   }
    let(:title)              { 'Test'                                  }
    let(:title_slug)         { title.downcase                          }
    let(:link)               { Lingohub::Spec.project_link(title_slug) }
    let(:weburl)             { Lingohub::Spec.weburl(title_slug)       }
    let(:resources_url)      { "#{link}/resources"                     }
    let(:collaborators_url)  { "#{link}/collaborators"                 }
    let(:invitations_url)    { "#{link}/invitations"                   }
    let(:translations_url)   { "#{link}/translations"                  }
    let(:search_url)         { "#{link}/resources/search"              }
    let(:translations_count) { 0                                       }

    before do
      projects.create(title)
    end

    after do
      projects[title].destroy
    end

    its(:owner)              { should == owner  }
    its(:title)              { should == title  }
    its(:link)               { should == link   }
    its(:weburl)             { should == weburl }
    its(:resources_url)      { should == resources_url }
    its(:collaborators_url)  { should == collaborators_url }
    its(:invitations_url)    { should == invitations_url   }
    its(:translations_url)   { should == translations_url   }
    its(:search_url)         { should == search_url   }

    its(:translations_count) do
      pending 'this should imo return 0 but returns nil instead'
      should == translations_count
    end

  end

  describe '#destroy' do

    subject { project.destroy }

    let(:project)            { projects[title]                         }
    let(:projects)           { Lingohub::Spec.projects                 }
    let(:title)              { 'Test'                                  }

    before do
      projects.create(title)
    end

    it 'should destroy the project' do
      subject
      Lingohub::Spec.projects.all.should be_empty
    end
  end
end
