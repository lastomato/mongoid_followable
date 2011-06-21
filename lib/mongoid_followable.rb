module Mongoid
  module Followable
    extend ActiveSupport::Concern

    included do |base|
      base.field :follower, :type => Array, :default => []
      base.field :followee, :type => Array, :default => []
    end

    module ClassMethods
    	# get a list of followers of certain model
    	#
    	# Example:
    	#		>> @Jim = User.new
    	#   >> @Tom = User.new
    	#		>> @Jim.save
    	#   >> @Tom.save
    	#		>> @Jim.follow(@Tom)
    	#		>> User.followers_of(@Tom)
    	#		=> [@Jim]
    	#
    	#	Arguments:
    	#		model: (instance of model(like User, Group))
      def followers_of(model)
        self.any_in(:_id => model.follower)
      end

    	# get a list of followees of certain model
    	#
    	# Example:
    	#		>> @Jim = User.new
    	#   >> @Tom = User.new
    	#		>> @Jim.save
    	#   >> @Tom.save
    	#		>> @Jim.follow(@Tom)
    	#		>> User.followees_of(@Jim)
    	#		=> [@Tom]
    	#
    	#	Arguments:
    	#		model: (instance of model(like User, Group))
      def followees_of(model)
        self.any_in(:_id => model.followee)
      end
    end

   	# judge whether a model is follower of another model
   	#
   	# Example:
   	#		>> @Jim = User.new
   	#   >> @Tom = User.new
   	#		>> @Jim.save
   	#   >> @Tom.save
   	#		>> @Jim.follow(@Tom)
   	#		>> @Jim.follower_of?(@Tom)
   	#		=> true
   	#
   	#	Arguments:
    #		model: (instance of model(like User, Group))
    def follower_of?(model)
      return true if model.follower.include?(self.id) and self.followee.include?(model.id)
    end
    
   	# judge whether a model is followee of another model
   	#
   	# Example:
   	#		>> @Jim = User.new
   	#   >> @Tom = User.new
   	#		>> @Jim.save
   	#   >> @Tom.save
   	#		>> @Jim.follow(@Tom)
   	#		>> @Tom.followee_of?(@Jim)
   	#		=> true
   	#
   	#	Arguments:
    #		model: (instance of model(like User, Group))
    def followee_of?(model)
      return true if model.followee.include?(self.id) and self.follower.include?(model.id)
    end

   	# follow a model
   	#
   	# Example:
   	#		>> @Jim = User.new
   	#   >> @Tom = User.new
   	#		>> @Jim.save
   	#   >> @Tom.save
   	#		>> @Jim.follow(@Tom)
   	#
   	#	Arguments:
    #		model: (instance of model(like User, Group))
    def follow(model)
      unless model == self
        model.follower |= [self.id]
        self.followee |= [model.id]
      end
    end

   	# cancel following a model
   	#
   	# Example:
   	#		>> @Jim = User.new
   	#   >> @Tom = User.new
   	#		>> @Jim.save
   	#   >> @Tom.save
   	#		>> @Jim.follow(@Tom)
   	#		>> @Jim.unfollow(@Tom)
   	#
   	#	Arguments:
    #		model: (instance of model(like User, Group))
    def unfollow(model)
      unless model == self
        model.follower -= [self.id]
        self.followee -= [model.id]
      end
    end

   	# count followers of a model
   	#
   	# Example:
   	#		>> @Jim = User.new
   	#   >> @Tom = User.new
   	#		>> @Jim.save
   	#   >> @Tom.save
   	#		>> @Jim.follow(@Tom)
   	#		>> @Tom.follower_count
   	#		=> 1
   	#
   	#	Arguments:
    #		none
    def follower_count
      self.follower.length
    end

   	# count followees of a model
   	#
   	# Example:
   	#		>> @Jim = User.new
   	#   >> @Tom = User.new
   	#		>> @Jim.save
   	#   >> @Tom.save
   	#		>> @Jim.follow(@Tom)
   	#		>> @Jim.followee_count
   	#		=> 1
   	#
   	#	Arguments:
    #		none
    def followee_count
      self.followee.length
    end
  end
end
