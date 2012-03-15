require 'spec_helper'

describe Lingohub::Models::Projects do

  let(:projects) { Lingohub::Spec.projects }
  let(:title)    { 'Test' }

  describe '#create' do
    subject { projects.create(title) }

    after do
      projects[title].destroy
    end

    it 'creates the project on the server' do
      subject
      projects[title].should be_instance_of(Lingohub::Models::Project)
    end
  end

  describe '#[]' do
    subject { projects[title] }

    context 'with no projects defined' do
      it { should be_nil }
    end

    context 'with projects defined' do

      before do
        projects.create(title)
      end

      after do
        projects[title].destroy
      end

      it { should be_instance_of(Lingohub::Models::Project) }

      it 'returns the available project' do
        subject.title.should == title
      end
    end
  end

  describe '#all' do

    subject { projects.all }

    context 'with no projects defined' do
      it { should be_empty }
    end

    context 'with projects defined' do

      let(:project) { subject[title] }

      before do
        projects.create(title)
      end

      after do
        projects[title].destroy
      end

      it { should_not be_empty }

      it 'returns the available project' do
        project.title.should == title
      end
    end
  end
end
