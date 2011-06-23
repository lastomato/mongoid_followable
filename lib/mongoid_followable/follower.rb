module Mongoid
  module Follower
    extend ActiveSupport::Concern

    included do |base|
      base.has_many :followees, :class_name => "Follow", :as => :following, :dependent => :destroy
    end

    module ClassMethods

      # get certain model's followers of this type
      #
      # Example:
      #   >> @jim = User.new
      #   >> @ruby = Group.new
      #   >> @jim.save
      #   >> @ruby.save
      #
      #   >> @jim.follow(@ruby)
      #   >> User.followers_of(@ruby)
      #   => [@jim]
      #
      #   Arguments:
      #     model: instance of some followable model

      def followers_of(model)
        model.followers_by_type(self.name)
      end

    end

    # see if this model is follower of some model
    #
    # Example:
    #   >> @jim.follower_of?(@ruby)
    #   => true

    def follower_of?(model)
      0 < self.followees.by_model(model).limit(1).count * model.followers.by_model(self).limit(1).count
    end

    # get all the followees of this model, same with classmethod followees_of
    #
    # Example:
    #   >> @jim.all_followees
    #   => [@ruby]

    def all_followees
      rebuild_instances(self.followees)
    end

    # get all the followees of this model in certain type
    #
    # Example:
    #   >> @ruby.followees_by_type("group")
    #   => [@ruby]

    def followees_by_type(type)
      rebuild_instances(self.followees.by_type(type))
    end

    # follow some model

    def follow(*models)
      models.each do |model|
        unless model == self or self.follower_of?(model) or model.followee_of?(self)
          model.followers.create!(:f_type => self.class.name, :f_id => self.id.to_s)
          self.followees.create!(:f_type => model.class.name, :f_id => model.id.to_s)
        end
      end
    end

    # unfollow some model

    def unfollow(*models)
      models.each do |model|
        unless model == self or !self.follower_of?(model) or !model.followee_of?(self)
          model.followers.by_model(self).first.destroy
          self.followees.by_model(model).first.destroy
        end
      end
    end

    # get the number of followees
    #
    # Example:
    #   >> @jim.followers_count
    #   => 1

    def followees_count
      self.followees.count
    end

    # get the number of followers in certain type
    #
    # Example:
    #   >> @ruby.followers_count_by_type("user")
    #   => 1

    def followees_count_by_type(type)
      self.followees.by_type(type).count
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
