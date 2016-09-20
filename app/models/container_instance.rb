class ContainerInstance < ActiveRecord::Base
  belongs_to :docker_configuration
  belongs_to :submission
  has_many :container_logs, dependent: :destroy

  as_enum :status, [:initialized, :built, :started, :error, :deleted, :completed], map: :string

  default_scope { order('id DESC') }
end
