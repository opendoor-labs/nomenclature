class NomsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_token
  before_action :find_team

  def nom
    text = params[:text]
    term = @team.terms.find_by(name: text)
    term ||= OpenStruct.new(
      name: text,
      description: "I don't know about #{text} yet",
    )
    response_type = params[:command] == '/nomp' ? 'in_channel' : 'ephemeral'
    render json: term, serializer: TermSerializer, serializer_params: {response_type: response_type}
  end

  def define
    term = @team.terms.from_text(params[:text])
    if term.save
      render json: term, serializer: TermSerializer, serializer_params: {response_type: 'ephemeral'}
    else
      term = OpenStruct.new(
        name: nil,
        description: 'Unable to define term. USAGE: /define TERM: DESCRIPTION'
      )
      render json: term, serializer: TermSerializer, serializer_params: {response_type: 'ephemeral'}
    end
  end

  private
  def find_team
    @team = Team.find_by!(slack_team_id: params[:team_id])
  end
end
