defmodule Sofa.Repo.Migrations.AddSizeToFile do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :size, :integer
    end

  end
end
