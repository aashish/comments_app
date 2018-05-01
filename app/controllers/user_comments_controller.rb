class UserCommentsController < ApplicationController
  before_action :set_user_comment, only: :destroy
  before_action :set_user_comments, only: [:index, :create]

  # GET /user_comments
  # GET /user_comments.json
  def index
    @user_comment = UserComment.new
  end

  # POST /user_comments
  # POST /user_comments.json
  def create
    @user_comment = UserComment.new(user_comment_params)
    @user_comment.ip = request.remote_ip

    respond_to do |format|
      if @user_comment.save
        format.js
        format.html { redirect_to @user_comment, notice: 'User comment was successfully created.' }
        format.json { render :show, status: :created, location: @user_comment }
      else
        format.html { render :new }
        format.json { render json: @user_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_comments/1
  # DELETE /user_comments/1.json
  def destroy
    @user_comment.destroy
    respond_to do |format|
      format.html { redirect_to user_comments_url, notice: 'User comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user_comment
      @user_comment = UserComment.find(params[:id])
    end

    def set_user_comments
      @user_comments = UserComment.valid_comments(request.remote_ip).reverse
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_comment_params
      params.require(:user_comment).permit(:description)
    end
end
