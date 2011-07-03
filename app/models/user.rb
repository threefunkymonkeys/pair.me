class User < ActiveRecord::Base
  has_secure_password
  has_many :user_friends
  has_many :friends, :through => :user_friends, :class_name => "User"

  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email

  def add_friend(friend)
    unless friend.nil? or friends.map(&:email).include? friend.email
      friends << friend
    end
  end
end
