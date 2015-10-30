[![Build Status](https://travis-ci.org/marcelog/elixir_freshbooks.svg)](https://travis-ci.org/marcelog/elixir_freshbooks)

# ElixirFreshbooks

An [Elixir](http://elixir-lang.org/) client for the [FreshBooks](http://freshbooks.com) API.

This is a work *in progress*. This means that there are a limited set of features available (i.e:
the ones I need right now :)) so pull requests to add new features are **highly** appreciated :)

----

# Using it with Mix

To use it in your Mix projects, first add it as a dependency:

```elixir
def deps do
  [{:elixir_freshbooks, "~> 0.0.1"}]
end
```
Then run mix deps.get to install it.

----

# Configuring
In your config.exs, setup the following section:

```elixir
config :elixir_freshbooks,
  url: "https://sample.freshbooks.com/api/2.1/xml-in",
  token: "token"
```

In your freshbooks account you should find both values.

----

# Documentation

Clients are used via the [Client](https://github.com/marcelog/elixir_freshbooks/blob/master/lib/elixir_freshbooks/client.ex) module.

```elixir
alias ElixirFreshbooks.Client, as: C
```

### Creating
```elixir
  > C.create "first_name", "last_name", "organization", "user@host.com"
  %ElixirFreshbooks.Client{
    email: "user@host.com",
    first_name: "first_name",
    id: 4422,
    last_name: "last_name",
    organization: "organization"
  }
```

----

# License
The source code is released under Apache 2 License.

Check [LICENSE](https://github.com/marcelog/elixir_freshbooks/blob/master/LICENSE) file for more information.
