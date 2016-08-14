require 'rails_helper'

describe NomsController do
  fixtures :teams, :terms
  let(:params) {
    {
      token: Rails.application.secrets.slack_token,
      team_id: teams(:first).slack_team_id,
      team_domain: 'opendoor',
      channel_id: 'C2147483705',
      channel_name: 'test',
      user_id: 'U2147483697',
      user_name: 'Steve',
      response_url: 'https://hooks.slack.com/commands/1234/5678',
    }.merge(param_overrides)
  }

  describe '#nom' do
    let(:param_overrides) {
      {
        command: '/nom',
        text: 'nom',
      }
    }

    it 'verifies token' do
      process :nom, method: :post, params: params.merge(token: 'bad')
      expect(response.status).to eq(403)
    end

    it 'verities team' do
      expect {
        process :nom, method: :post, params: params.merge(team_id: 'bad')
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a term' do
      process :nom, method: :post, params: params
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('Nom: ' + terms(:nom).description)
    end

    it 'does not find other teams terms' do
      process :nom, method: :post, params: params.merge(team_id: teams(:second).slack_team_id)
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq("nom: I don't know about nom yet")
    end

    it 'is case insensitive' do
      process :nom, method: :post, params: params.merge(text: 'NOM')
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('Nom: ' + terms(:nom).description)
    end

    it 'returns a term publically' do
      process :nom, method: :post, params: params.merge(command: '/nomp')
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('in_channel')
    end

    it 'handles unknown terms' do
      process :nom, method: :post, params: params.merge(text: 'blah')
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq("blah: I don't know about blah yet")
    end
  end

  describe '#define' do
    let(:param_overrides) {
      {
        command: '/define',
        text: 'eat: to eat food',
      }
    }

    it 'defines a term' do
      expect {
        process :define, method: :post, params: params
        expect(response.status).to be(200)
      }.to change(Term, :count).by(1)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('eat: to eat food')
    end

    it 'defines a term without a colon' do
      expect {
        process :define, method: :post, params: params.merge(text: 'eat to eat food')
        expect(response.status).to be(200)
      }.to change(Term, :count).by(1)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('eat: to eat food')
    end

    it 'updates a terms' do
      expect {
        process :define, method: :post, params: params.merge(text: 'NOM: to nom a thing')
        expect(response.status).to be(200)
      }.to_not change(Term, :count)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('NOM: to nom a thing')
    end

    it 'handles a missing description' do
      expect {
        process :define, method: :post, params: params.merge(text: 'NOM: ')
        expect(response.status).to be(200)
      }.to_not change(Term, :count)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('Unable to define term. USAGE: /define TERM: DESCRIPTION')
    end

    it 'handles a missing name' do
      expect {
        process :define, method: :post, params: params.merge(text: '')
        expect(response.status).to be(200)
      }.to_not change(Term, :count)
      data = JSON.parse(response.body)
      expect(data['response_type']).to eq('ephemeral')
      expect(data['text']).to eq('Unable to define term. USAGE: /define TERM: DESCRIPTION')
    end
  end
end
