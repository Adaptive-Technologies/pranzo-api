class Orders::IndexSerializer < ActiveModel::Serializer
  attributes :id, :table, :time
  belongs_to :user, scope: :currrent_user, serializer: Users::ShowSerializer
  has_many :items, serializer: Items::ShowSerializer

  def time
    object.created_at.strftime('%H:%M')
  end
end
