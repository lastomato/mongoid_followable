class Follow
  include Mongoid::Document

  field :f_type, :type => String
  field :f_id, :type => String

  belongs_to :followable, :polymorphic => true
  belongs_to :following, :polymorphic => true

  scope :by_type, lambda { |type| where(:f_type => type.capitalize) }
  scope :by_model, lambda { |model| where(:f_id => model.id.to_s).by_type(model.class.name) }
end