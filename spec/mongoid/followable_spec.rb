require 'spec_helper'

module Mongoid
  describe User do

    let!(:u) { User.new }

    context "certain user" do

      before do
      	u.save
        @v = User.new
        @v.save
      end

      it "follows a user" do
        u.follow(@v)
        u.followee.include?(@v.id).should be_true
        @v.follower.include?(u.id).should be_true

        u.follower_of?(@v).should be_true
        u.followee_of?(@v).should be_false
        @v.follower_of?(u).should be_false
        @v.followee_of?(u).should be_true

        u.follower_of?(u).should be_false
        @v.followee_of?(@v).should be_false
        @v.follower_of?(@v).should be_false
        u.followee_of?(u).should be_false

        u.follower_count.should == 0
        @v.follower_count.should == 1
        u.followee_count.should == 1
        @v.followee_count.should == 0

        User.followers_of(@v).should == [u]
        User.followees_of(@v).should == []
        User.followers_of(u).should == []
        User.followees_of(u).should == [@v]
      end

      it "unfollows a user" do
        u.unfollow(@v)
        u.followee.include?(@v.id).should be_false
        @v.follower.include?(u.id).should be_false

        u.follower_of?(@v).should be_false
        u.followee_of?(@v).should be_false
        @v.follower_of?(u).should be_false
        @v.followee_of?(u).should be_false

        u.follower_of?(u).should be_false
        @v.followee_of?(@v).should be_false
        @v.follower_of?(@v).should be_false
        u.followee_of?(u).should be_false

        u.follower_count.should == 0
        @v.follower_count.should == 0
        u.followee_count.should == 0
        @v.followee_count.should == 0

        User.followers_of(u).should == []
        User.followees_of(u).should == []
        User.followers_of(@v).should == []
        User.followees_of(@v).should == []
      end

    end
  end
end
