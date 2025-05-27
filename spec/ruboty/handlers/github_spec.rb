# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe Ruboty::Handlers::Github do
  before do
    access_tokens.merge!(sender => stored_access_token)
  end

  let(:robot) do
    Ruboty::Robot.new
  end

  let(:stored_access_token) do
    github_access_token
  end

  let(:github_access_token) do
    'dummy'
  end

  let(:sender) do
    'bob'
  end

  let(:channel) do
    '#general'
  end

  let(:user) do
    'alice'
  end

  let(:repository) do
    'test'
  end

  let(:access_tokens) do
    robot.brain.data[Ruboty::Github::Actions::Base::NAMESPACE] ||= {}
  end

  let(:call) do
    robot.receive(body: body, from: sender, to: channel)
  end

  shared_examples_for 'requires access token without access token' do
    context 'without access token' do
      let(:stored_access_token) do
        nil
      end

      it 'requires access token' do
        expect(robot).to receive(:say).with(hash_including(body: "I don't know your github access token"))
        call
        expect(a_request(:any, //)).not_to have_been_made
      end
    end
  end

  describe '#create_issue' do
    before do
      stub_request(:post, "https://api.github.com/repos/#{user}/#{repository}/issues")
        .with(
          body: {
            labels: [],
            title: title,
            body: ''
          }.to_json,
          headers: {
            Authorization: "token #{github_access_token}"
          }
        )
    end

    let(:title) do
      'This is a test issue'
    end

    let(:body) do
      %(ruboty create issue "#{title}" on #{user}/#{repository})
    end

    it_behaves_like 'requires access token without access token'

    context 'with access token' do
      it 'creates a new issue with given title on given repository' do
        call
        expect(a_request(:any, //)).to have_been_made
      end
    end
  end

  describe '#search_issues' do
    before do
      stub_request(:get, "https://api.github.com/search/issues?q=#{query}")
        .with(
          headers: {
            Authorization: "token #{github_access_token}"
          }
        )
        .to_return(
          body: '',
          headers: {
            'Content-Type' => 'application/json'
          }
        )
    end

    let(:query) do
      'org:increments is:open is:public is:pr'
    end

    let(:body) do
      %(ruboty search issues "#{query}")
    end

    it_behaves_like 'requires access token without access token'

    context 'with access token' do
      it 'search an issue with given query' do
        call
        expect(a_request(:any, //)).to have_been_made
      end
    end
  end

  describe '#close_issue' do
    before do
      stub_request(:get, "https://api.github.com/repos/#{user}/#{repository}/issues/#{issue_number}")
        .with(
          headers: {
            Authorization: "token #{github_access_token}"
          }
        )
        .to_return(
          body: {
            state: issue_status,
            html_url: html_url
          }.to_json,
          headers: {
            'Content-Type' => 'application/json'
          }
        )
      stub_request(:patch, "https://api.github.com/repos/#{user}/#{repository}/issues/#{issue_number}")
        .with(
          body: {
            state: 'closed'
          }.to_json,
          headers: {
            Authorization: "token #{github_access_token}"
          }
        )
    end

    let(:html_url) do
      "http://example.com/#{user}/#{repository}/issues/#{issue_number}"
    end

    let(:issue_status) do
      'open'
    end

    let(:body) do
      "@ruboty close issue #{user}/#{repository}##{issue_number}"
    end

    let(:issue_number) do
      1
    end

    it_behaves_like 'requires access token without access token'

    context 'with closed issue' do
      it 'replies so' do
        expect(robot).to receive(:say).with(hash_including(body: "Closed #{html_url}"))
        call
      end
    end

    context 'with access token' do
      it 'closes specified issue' do
        call
      end
    end
  end

  describe '#remember' do
    let(:body) do
      "@ruboty remember my github token #{github_access_token}"
    end

    it "remembers sender's access token in its brain" do
      expect(robot).to receive(:say).with(hash_including(body: "Remembered #{sender}'s github access token"))
      call
      expect(access_tokens[sender]).to eq(github_access_token)
    end
  end
end
