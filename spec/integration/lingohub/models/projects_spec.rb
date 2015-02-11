require 'spec_helper'

describe Lingohub::Models::Projects do

  let(:projects) { Lingohub::Spec.projects }
  let(:title)    { 'Test'                  }

  describe '#[]' do
    subject { projects[title] }

    context 'when the given title is nil' do
      let(:title) { nil }

      it { should be_nil }
    end

    context 'when no project with the given title is available' do
      let(:title) { 'N/A' }

      it { should be_nil }
    end

    context 'when a project with the given title is available' do

      before do
        projects.create(title)
      end

      after do
        projects[title].destroy
      end

      it { should be_instance_of(Lingohub::Models::Project) }

      it 'should be the requested project' do
        subject.title.should == title
      end
    end
  end

  describe '#all' do

    subject { projects.all }

    context 'when no projects are available' do
      it { should be_instance_of(Hash) }
      it { should be_empty             }
    end

    context 'when projects are available' do

      let(:project) { subject[title] }

      before do
        projects.create(title)
      end

      after do
        projects[title].destroy
      end

      it { should be_instance_of(Hash) }
      it { should have_key(title)      }

      it 'should return a project keyed by its title' do
        subject[title].title.should == title
      end
    end
  end
end
