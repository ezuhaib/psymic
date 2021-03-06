class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities


    user ||= User.new # guest user (not logged in)

    # all users
    can :read , [Mindlog,Response,Comment,User,Feedback,WikiPage,Channel,Comic]

    if user.username # authenticated users
      can :read , [Message,:notification]
      can [:respond,:rate] , Mindlog
      can [:report,:subscribe,:unsubscribe,:add_to_channel] , Mindlog do |x|
        x.try(:user) != user
      end
      can :vote , Response
      # for some reason if :all is used below, it authorizes update/destroy on wikipages for all users
      can :update , [Mindlog,Response,Comment,Feedback] do |x|
          x.try(:user) == user
      end
      can :destroy , [Mindlog,Response,Comment,Feedback,Comic] do |x|
          x.try(:user) == user
          x.created_at > 15.minutes.ago
      end
      can :update , User do |u|
        u.try(:id) == user.id
      end
      can :create , [Mindlog,Response,Comment,Feedback,Comic,Message]
      can :authenticate , :psymic #checks if user logged in
      can :read_unpublished , [Mindlog,Comic] do |x|
        x.try(:user) == user
      end
    end

    if user.role? "moderator"
      can :admin , :all #access to admin/ pages
      can :moderate , [Mindlog,Comic] #allows featuring,publishing/unpublishing and setting status
      can :read , Report
      can :read_unpublished , [Mindlog,Comic]
      can :update , :all
      can :destroy, :all
      can :backstage, Feedback
      can :manage , WikiPage
      can :publish , Mindlog
    end

    # although admin has all permissions, exclusive permissions are
    # still enlisted for reference
    if user.role? "admin"
      can :manage, :all
      can [:update,:destroy] , :message
    end

  end
end
