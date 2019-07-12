# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end


    can :crud, Article do |article|
      article.user == user
    end

    if user.is_admin?
      can :manage, :all
      end 

    alias_action :create, :read, :update, :destroy, to: :crud
  
    can(:crud, Product) do |product|
      product.user == user 
    end 

    can(:crud, Review) do |review|
      # review.user == user || review.question.user = user
      review.user == user
    end
  end
  
end
