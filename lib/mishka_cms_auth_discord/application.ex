# SPDX-FileCopyrightText: 2026 Mishka Group contributors <https://github.com/mishka-group/mishka_cms_auth_discord/graphs/contributors>
#
# SPDX-License-Identifier: Apache-2.0

defmodule MishkaCmsAuthDiscord.Application do
  @moduledoc false
  use Application

  # The provider plugin registers itself on `"auth:providers"` once it starts.
  @impl true
  def start(_type, _args),
    do:
      Supervisor.start_link([MishkaCmsAuthDiscord],
        strategy: :one_for_one,
        name: MishkaCmsAuthDiscord.Supervisor
      )
end
