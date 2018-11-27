class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @item = Item.find(params[:relationship][:followed_id])
    current_user.follow!(@item)
    respond_to do |format|
      format.html { redirect_to @item }
      format.js
    end
  end

  def destroy
    @item = Relationship.find(params[:id]).followed
    current_user.unfollow!(@item)
    respond_to do |format|
      format.html { redirect_to @item }
      format.js
    end
  end
end