class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  belongs_to :user

  def to_hash
    {
      text: comment,
      created_at: created_at.to_s(:short),
      location_id: commentable_id,
      user: user.login,
      thumb: "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.login)}?d=identicon&s=25"
    }
  end

end
