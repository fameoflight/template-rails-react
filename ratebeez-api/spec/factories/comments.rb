# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  commentable_type  :string           not null, indexed => [commentable_id]
#  discarded_at      :datetime         indexed
#  rating            :decimal(5, 2)
#  rich_text_content :jsonb            not null
#  tags              :string           default([]), is an Array
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  commentable_id    :bigint           not null, indexed => [commentable_type]
#  user_id           :bigint           not null, indexed
#
# Indexes
#
#  index_comments_on_commentable   (commentable_type,commentable_id)
#  index_comments_on_discarded_at  (discarded_at)
#  index_comments_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#
FactoryBot.define do
  factory :comment do
    association :commentable, factory: :blog_post
    association :user
    rich_text_content { { content: '{}', format: 'plain' } }
    tags { %w[tag1 tag2] }
    rating { 5 }
  end
end
