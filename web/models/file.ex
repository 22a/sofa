defmodule Sofa.SFile do
  use Sofa.Web, :model

  schema "files" do
    field :name, :string
    field :size, :integer
    field :last_updated, Ecto.DateTime
    belongs_to :user, Sofa.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :size, :last_updated, :user_id])
    |> validate_required([:name, :size, :last_updated, :user_id])
  end
end
