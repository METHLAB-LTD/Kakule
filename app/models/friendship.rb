class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key =>'friend_id'
  
  validates_uniqueness_of :friend_id, :scope => :user_id, :message => "Friendship already exists"
  validate :cannot_add_self
  
  
  
  
  private
  def cannot_add_self
     errors.add_to_base('You cannot add yourself as a friend.') if self.user_id == self.friend_id
   end
  
end
