# SPDX-FileCopyrightText: 2026 Mishka Group contributors <https://github.com/mishka-group/mishka_cms_auth_discord/graphs/contributors>
#
# SPDX-License-Identifier: Apache-2.0

defmodule MishkaCmsAuthDiscordTest do
  use ExUnit.Case, async: true

  test "is a sign-in provider for the core's discord strategy" do
    assert MishkaCmsCore.Accounts.SignInProvider in behaviours(MishkaCmsAuthDiscord)
    assert MishkaCmsAuthDiscord.id() == "discord"
    assert MishkaCmsAuthDiscord.strategy() == :discord
    assert MishkaCmsAuthDiscord.label() == "Discord"
    assert %{path: "M" <> _, color: "text-" <> _} = MishkaCmsAuthDiscord.icon()
  end

  test "asks each site for a client ID and a sealed client secret" do
    assert [
             %{key: "auth.providers.discord.client_id", type: :string, scope: :site},
             %{key: "auth.providers.discord.client_secret", type: :secret, scope: :site}
           ] = MishkaCmsAuthDiscord.settings()
  end

  test "hands AshAuthentication nothing it does not keep" do
    assert MishkaCmsAuthDiscord.secret(:team_id, "any-site") == :error
  end

  describe "Discord's user object, read as claims" do
    test "its id is the sub and its verified flag the email's" do
      assert %{"sub" => "80351110224678912", "email" => "a@example.com", "email_verified" => true} =
               MishkaCmsAuthDiscord.user_info(%{
                 "id" => 80_351_110_224_678_912,
                 "email" => "a@example.com",
                 "verified" => true
               })
    end

    test "an email is verified only when Discord says exactly true" do
      for answer <- [
            %{"id" => 1, "verified" => false},
            %{"id" => 2, "verified" => "true"},
            %{"id" => 3},
            %{"id" => 4, "email_verified" => true}
          ] do
        assert MishkaCmsAuthDiscord.user_info(answer)["email_verified"] == false, inspect(answer)
      end
    end
  end

  defp behaviours(module),
    do: module.module_info(:attributes) |> Keyword.get_values(:behaviour) |> List.flatten()
end
