require 'spec_helper'

describe Mongoid::Followable do

  describe User do

    let!(:u) { User.new }

    context "begins" do

      before do
      	u.save

        @v = User.new
        @v.save

        @g = Group.new
        @g.save
      end

      it "following a user" do
        u.follow(@v)

        u.follower_of?(@v).should be_true
        @v.followee_of?(u).should be_true

        u.all_followees.should == [@v]
        @v.all_followers.should == [u]

        u.followees_by_type("user").should == [@v]
        @v.followers_by_type("user").should == [u]

        u.followees_count.should == 1
        @v.followers_count.should == 1

        u.followees_count_by_type("user").should == 1
        @v.followers_count_by_type("user").should == 1
      end

      it "unfollowing a user" do
        u.unfollow(@v)

        u.follower_of?(@v).should be_false
        @v.followee_of?(u).should be_false

        u.all_followees.should == []
        @v.all_followers.should == []

        u.followees_by_type("user").should == []
        @v.followers_by_type("user").should == []

        u.followees_count.should == 0
        @v.followers_count.should == 0

        u.followees_count_by_type("user").should == 0
        @v.followers_count_by_type("user").should == 0
      end

      it "following a group" do
        u.follow(@g)

        u.follower_of?(@g).should be_true
        @g.followee_of?(u).should be_true

        u.all_followees.should == [@g]
        @g.all_followers.should == [u]

        u.followees_by_type("group").should == [@g]
        @g.followers_by_type("user").should == [u]

        u.followees_count.should == 1
        @g.followers_count.should == 1

        u.followees_count_by_type("group").should == 1
        @g.followers_count_by_type("user").should == 1
      end

      it "unfollowing a group" do
        u.unfollow(@g)

        u.follower_of?(@g).should be_false
        @g.followee_of?(u).should be_false

        u.all_followees.should == []
        @g.all_followers.should == []

        u.followees_by_type("group").should == []
        @g.followers_by_type("group").should == []

        u.followees_count.should == 0
        @g.followers_count.should == 0

        u.followees_count_by_type("group").should == 0
        @g.followers_count_by_type("group").should == 0
      end
    end
  end
end
