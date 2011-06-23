class User
  include Mongoid::Document
  include Mongoid::Followable
  include Mongoid::Follower
end