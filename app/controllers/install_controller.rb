class InstallController < ApplicationController
  def install
    oauth_params = {
      code: params[:code],
      client_id: Rails.application.secrets.slack_key,
      client_secret: Rails.application.secrets.slack_secret,
    }
    response = Excon.post('https://slack.com/api/oauth.access', body: URI.encode_www_form(oauth_params))
    data = JSON.parse(response.body)
    team = Team.find_or_initialize_by(slack_team_id: data['team_id'])
    team.update_attributes!(
      team_name: data['team_name'],
      access_token: data['access_token'],
      install_scope: data['scope'],
      installing_user_id: data['user_id'],
    )
    render plain: 'Nomenclature is installed, you are ready to go!'
  end
end
