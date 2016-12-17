defmodule Sofa.SFile do
  use Sofa.Web, :model

  schema "files" do
    field :name, :string
    field :size, :integer
    belongs_to :user, Sofa.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :size, :user_id])
    |> validate_required([:name, :size, :user_id])
  end
end
