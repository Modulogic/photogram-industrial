class FollowRequestsController < ApplicationController
  before_action :set_follow_request, only: %i[ show edit update destroy ]

  # GET /follow_requests
  def index
    @follow_requests = FollowRequest.all
  end

  # GET /follow_requests/1
  def show
  end

  # GET /follow_requests/new
  def new
    @follow_request = FollowRequest.new
  end

  # GET /follow_requests/1/edit
  def edit
  end

  # POST /follow_requests
  def create
    # Build a new follow request using the permitted parameters (which only permit recipient_id)
    @follow_request = FollowRequest.new(follow_request_params)
    # Set the sender to the currently signed-in user
    @follow_request.sender = current_user

    if @follow_request.save
      # Instead of redirecting to the follow request's show page,
      # redirect back to the recipient's profile with the text "Un-request"
      redirect_to user_path(@follow_request.recipient.username), notice: "Un-request"
    else
      redirect_to user_path(@follow_request.recipient.username), alert: @follow_request.errors.full_messages.to_sentence
    end
  end

  # PATCH/PUT /follow_requests/1
  def update
    respond_to do |format|
      if @follow_request.update(follow_request_params)
        format.html { redirect_to @follow_request, notice: "Follow request was successfully updated." }
        format.json { render :show, status: :ok, location: @follow_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @follow_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follow_requests/1
  def destroy
    @follow_request.destroy!

    respond_to do |format|
      format.html { redirect_to follow_requests_path, status: :see_other, notice: "Follow request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow_request
      @follow_request = FollowRequest.find(params.expect(:id))
    end

    # Only allow the recipient_id (and optionally :status if needed) through.
    # Remove sender_id because we set that in the controller.
    def follow_request_params
      params.expect(follow_request: [ :recipient_id, :status ])
    end
end
