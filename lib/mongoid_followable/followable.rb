module Mongoid
  module Followable
    extend ActiveSupport::Concern

    included do |base|
      base.field :cannot_followed, :type => Array, :default => []
      base.field :followed_history, :type => Array, :default => []
      base.has_many :followers, :class_name => "Follow", :as => :followable, :dependent => :destroy
    end

    module ClassMethods

      # get certain model's followees of this type
      #
      # Example:
      #   >> @jim = User.new
      #   >> @ruby = Group.new
      #   >> @jim.save
      #   >> @ruby.save
      #
      #   >> @jim.follow(@ruby)
      #   >> User.followees_of(@jim)
      #   => [@ruby]
      #
      #   Arguments:
      #     model: instance of some followable model

      def followees_of(model)
        model.followees_by_type(self.name)
      end

    end

    # set which models cannot follow self
    #
    # Example:
    #   >> @ruby.set_authorization('user')
    #   => true

    def set_authorization(*models)
      models.each do |model|
        self.cannot_followed << model.capitalize
      end
      self.save
    end

    def unset_authorization(*models)
      models.each do |model|
        self.cannot_followed -= [model.capitalize]
      end
      self.save
    end

    # see if this model is followee of some model
    #
    # Example:
    #   >> @ruby.followee_of?(@jim)
    #   => true

    def followee_of?(model)
      0 < self.followers.by_model(model).limit(1).count * model.followees.by_model(self).limit(1).count
    end

    # get all the followers of this model, same with classmethod followers_of
    #
    # Example:
    #   >> @ruby.all_followers
    #   => [@jim]

    def all_followers
      rebuild_instances(self.followers)
    end

    # get all the followers of this model in certain type
    #
    # Example:
    #   >> @ruby.followers_by_type("user")
    #   => [@jim]

    def followers_by_type(type)
      rebuild_instances(self.followers.by_type(type))
    end

    # get the number of followers
    #
    # Example:
    #   >> @ruby.followers_count
    #   => 1

    def followers_count
      self.followers.count
    end

    # get the number of followers in certain type
    #
    # Example:
    #   >> @ruby.followers_count_by_type("user")
    #   => 1

    def followers_count_by_type(type)
      self.followers.by_type(type).count
    end

    # see model's followed history
    #
    # Example:
    #   >> @ruby.ever_followed
    #   => [@jim]

    def ever_followed
      follow = []
      self.followed_history.each do |h|
        follow << h.split('_')[0].constantize.find(h.split('_')[1])
      end
      follow
    end

    private
      def rebuild_instances(follows)
        follow_list = []
        follows.each do |follow|
          follow_list << follow.f_type.capitalize.constantize.find(follow.f_id)
        end
        follow_list
      end
  end
end
