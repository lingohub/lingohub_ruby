require 'spec_helper'

describe Lingohub::Models::Projects do

  let(:projects) { Lingohub::Spec.projects }
  let(:title)    { 'Test'                  }

  describe '#create' do

    subject { OkJson.decode(response) }

    let(:response) { projects.create(title) }

    context 'when an invalid title is given' do

      context 'when nil is given as title' do
        let(:title) { nil }

        specify { expect { subject }.to raise_error(RestClient::BadRequest) }
      end

      context 'when an already existing title is given' do
        before do
          projects.create(title)
        end

        after do
          projects[title].destroy
        end

        specify { expect { subject }.to raise_error(RestClient::BadRequest) }
      end
    end

    context 'when a valid title is given' do

      after do
        projects[title].destroy
      end

      it { should be_instance_of(Hash) }

      specify do
        expect { subject }.to change { Lingohub::Spec.projects.all.size }.by(1)
      end

      it 'should create the project on the server' do
        subject
        Lingohub::Spec.projects[title].title.should == title
      end
    end
  end

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
