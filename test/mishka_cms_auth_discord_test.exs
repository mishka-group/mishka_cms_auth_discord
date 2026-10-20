# SPDX-FileCopyrightText: 2026 Mishka Group contributors <https://github.com/mishka-group/mishka_cms_auth_discord/graphs/contributors>
#
# SPDX-License-Identifier: Apache-2.0

defmodule MishkaCmsAuthDiscordTest do
  use ExUnit.Case, async: true

  test "is a sign-in provider Assent speaks to" do
    assert MishkaCmsCore.Accounts.SignInProvider in behaviours(MishkaCmsAuthDiscord)
    assert MishkaCmsAuthDiscord.id() == "discord"
    assert %{assent: Assent.Strategy.Discord} = MishkaCmsAuthDiscord.oauth()
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

  test "speaks to discord.com, not Assent's older discordapp.com" do
    assert %{base_url: "https://discord.com/api"} = MishkaCmsAuthDiscord.oauth()
  end

  defp behaviours(module),
    do: module.module_info(:attributes) |> Keyword.get_values(:behaviour) |> List.flatten()
end
