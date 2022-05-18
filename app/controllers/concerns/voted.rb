module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    @votable.vote_up(current_user)
    render_json
  end

  def vote_down
    @votable.vote_down(current_user)
    render_json
  end

  def cancel_vote
    @votable.cancel_vote_of(current_user)
    render_json
  end

  private

  def render_json
    render json: { resourceName: @votable.class.name.downcase,
                   resourceId: @votable.id,
                   rating: @votable.rating }
  end

  def model_class
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_class.find(params[:id])
  end
end
