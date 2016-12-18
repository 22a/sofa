defmodule Sofa.Repo.Migrations.AddLastupdatedToFile do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :last_updated, :datetime
    end
  end
end
