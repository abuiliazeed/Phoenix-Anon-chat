defmodule AnonChat.Repo.Migrations.AddUsernameToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :username, :string, null: false, default: "Anonymous"
    end
  end
end
