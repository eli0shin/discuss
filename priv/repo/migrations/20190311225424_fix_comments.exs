defmodule Discuss.Repo.Migrations.FixComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      remove(:contetn)
      add(:content, :string)
    end
  end
end
