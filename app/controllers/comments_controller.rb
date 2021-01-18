class CommentsController < ApplicationController
  def create    
    @comment = Comment.new(comment_params)
    if @comment.save
      ActionCable.server.broadcast 'comment_channel', text: @comment.text, time: @comment.created_at , user_name: @comment.user.nickname
    end
  end

  def comment_params
    params.require(:comment).permit(
      :text
    ).merge(item_id: params[:item_id], user_id: current_user.id)
  end
end
