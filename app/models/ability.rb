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

    # Special admin roles being used:
    # :monitor(for searchkick)
    if user.role? "admin"
      can :manage, :all
    elsif user.role? "moderator"
      can :admin , :all #access to admin/ pages
      can :read , Report
      can :update , :all
      can :destroy, :all
      can :backstage, Feedback
    elsif user.username # authenticated users
      can [:report,:subscribe,:unsubscribe,:respond] , :Mindlog
      can :read , Feedback
      can :vote , Response
      can [:update,:destroy] , :all do |x|
          x.try(:user) == user
      end
      can :update , User do |u|
        u.try(:id) == user.id
      end
      can :create , [Mindlog,Response,Comment]
    end

    # all users authenticted an anonymous:
    # Anonymous users currently not allowed access to anything
    #can :read , [Mindlog,Response,Comment,User]

  end
end
