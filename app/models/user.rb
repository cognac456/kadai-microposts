class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  
  # def microposts
  #   Micropost.where(user_id: self.id)
  # end
  
  has_many :relationships
  
  # def relationships
  #   Relationship.where(user_id: self.id)
  # end
  
  has_many :followings, through: :relationships, source: :follow #XX_idを指定 ここではfollow_id
  
  # def followings
  #   User.where(id: self.relationships.pluck(:follow_id))
  # end

  has_many :reverse_of_relationship, class_name: "Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverse_of_relationship, source: :user 
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  
end
