require 'rails_helper'

describe InstallController do
  render_views

  let(:response_body) {
    '{"ok":true,"access_token":"xoxp-xxxxxxx","scope":"identify,commands","user_id":"U123","team_name":"name","team_id":"T123","warning":"missing_charset"}'
  }

  describe '#install' do
    it 'generates a team' do
      stub_request(:any, 'https://slack.com/api/oauth.access').with do |request|
        params = URI.decode_www_form(request.body).to_h
        expect(params['code']).to eq('123')
        expect(params['client_id']).to eq(Rails.application.secrets.slack_key)
        expect(params['client_secret']).to eq(Rails.application.secrets.slack_secret)
      end.to_return(body: response_body)
      expect {
        process :install, method: :get, params: {code: '123'}
        expect(response.status).to eq(200)
      }.to change(Team, :count).by(1)
      team = Team.last
      expect(team.slack_team_id).to eq('T123')
      expect(team.team_name).to eq('name')
      expect(team.install_scope).to eq('identify,commands')
      expect(team.access_token).to eq('xoxp-xxxxxxx')
      expect(team.installing_user_id).to eq('U123')
    end


    it 'updates a team' do
      team = Team.create!(slack_team_id: 'T123', team_name: 'a', access_token: 'a', install_scope: 'a', installing_user_id: '1')
      stub_request(:any, 'https://slack.com/api/oauth.access').to_return(body: response_body)
      expect {
        process :install, method: :get, params: {code: '123'}
        expect(response.status).to eq(200)
      }.to_not change(Team, :count)
      team.reload
      expect(team.slack_team_id).to eq('T123')
      expect(team.team_name).to eq('name')
      expect(team.install_scope).to eq('identify,commands')
      expect(team.access_token).to eq('xoxp-xxxxxxx')
      expect(team.installing_user_id).to eq('U123')
    end
  end
end
