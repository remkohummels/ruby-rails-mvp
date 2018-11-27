class LikesController < ApplicationController

  before_filter :get_votable
  before_filter :authenticate_user!

  def add_to_favorite
    authorize! :add_to_favorite, :likes
    @votable.liked_by current_user
    respond_to do |format|
      format.js
    end
  end

  def remove_from_favorite
    authorize! :remove_from_favorite, :likes
    @votable.unliked_by current_user
    respond_to do |format|
      format.js
    end
  end

  private
  def get_votable
    @klass = Object.const_get params[:obj]
    @votable = @klass.find(params[:id])
  end
end
