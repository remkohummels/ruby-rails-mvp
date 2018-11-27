class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else

      # Group
      can [:show, :load_more], Group
      can [:invite_to_group, :add_to_group, :remove_from_group, :update, :edit, :destroy,:appoint_admin, :demote_user], Group do |group|
        user.id == group.user_id
      end
      can [:invite_to_group], Group do |group|
        user.in_group?(group)
      end
      can [:invite_to_group, :add_to_group, :remove_from_group, :appoint_admin, :block_user, :unblock_user], Group do |group|
        group.user_is_admin?(user)
      end
      can [:remove_from_group], Group do |group|
        user.group_status(@group) == "joined"
      end

      can [:leave_group, :join_group], Group do |group|
        user.id != group.user_id
      end

      can [:index, :switch, :new, :create, :switch_group, :choose_group], Group

      # Bid
      can [:create], Bid do |bid|
        user.id && bid.user_id != user.id
      end

      # Item
      can [:read, :search, :create, :save_to_draft, :choose_type, :buy_now, :buy_free, :make_an_offer], Item


      # can [:buy_now, :buy_free], Item do |i|
      #   user && i.user_id != user.id
      # end
      can [:choose_winner, :set_winner, :finish_item, :publish], Item do |item|
        user.id == item.user.id
      end

      can [:update, :destroy, :activate_payment], Item, user_id: user.id if user.id
      can [:buy_item], Item, winner_id: user.id
      can [:premium_payment], Item do |i|
        !i.is_premium && i.user_id == user.id
      end

      cannot [:show], Item
      can [:show], Item do |i|
        i.active? || i.user == user || i.winner == user
      end

      #Disput
      can [:index], Disput
      can [:show], Disput do |d|
        d.user.id == user.id || d.item.user.id == user.id
      end

      can [:create, :open_disput_modal, :show], Disput do |d|
        d.item.winner.id == d.user_id && Item.find(d.item.id).disputs.blank?
      end

      #DisputComments
      can [:create], DisputComment do |c|
        c.disput.item.winner.id == c.user.id || c.disput.item.user.id == c.user.id
      end


      # Feedback
      can :manage, Feedback

      # Likes
      can [:remove_from_favorite, :add_to_favorite], :likes if user.id

      # User
      can [:dashboard, :feedbacks, :bids, :show, :items], User
      can [:edit, :update, :transactions, :security, :settings, :set_notification_permit], User do |u|
        user.id && u.id == user.id
      end

      cannot :destroy, User
    end
  end
end
