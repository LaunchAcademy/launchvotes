class Api::V1::VotesController < Api::V1::ApiController
  def create
    @nomination = Nomination.find(params[:nomination_id])
    @vote = Vote.find_or_create_by(nomination: @nomination, voter: current_user)
    respond_to do |format|
      format.json do
        render json: @vote
      end
    end
  end

  def destroy
    @nomination = Nomination.find(params[:nomination_id])
    @vote = Vote.find(params[:id])
    @vote.destroy
    respond_to do |format|
      format.json do
        render json: @vote
      end
    end
  end
end
