defmodule Sofa.File do
  use Sofa.Web, :model

  schema "files" do
    field :name, :string
    belongs_to :user, Sofa.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
