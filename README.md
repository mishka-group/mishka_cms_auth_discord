# Mishka CMS Auth Discord

Sign in with Discord for [Mishka CMS](https://mishka.tools/cms). Each site switches it on and
sets its own keys; no other setup is needed.

## Install

```elixir
# mix.exs
{:mishka_cms_auth_discord, "~> 0.0.1"}
```

Run `mix deps.get` and restart. The package registers itself with Mishka CMS through
`mishka_installer`; there is no config to add and no migration.

## Set up

1. Make the app at [discord.com/developers/applications](https://discord.com/developers/applications) → **New Application → OAuth2**.
2. Redirect (OAuth2 → Redirects): `https://<your-site>/api/auth/user/discord/callback`
3. In Mishka CMS: **Settings → Security → Sign-in methods** → switch **Discord** on. Paste the
   **Client ID** and **Client Secret (Reset Secret)** into the fields that open under it, then **Save**.

The Discord button now shows on the sign-in and registration pages.

## What it does

- Discord's own user object is read as claims: its `id` is the user's id and its `verified` says whether the email is confirmed. An account with no email, or an unverified one, does not sign in.
- Links to an existing confirmed account with the same email, and claims one nobody confirmed.
- Makes a new account only while the site allows it, and never makes a master.
- Asks for the authenticator code when the account has two-step sign-in.
- Keeps none of Discord's tokens.

## License

Apache-2.0
