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

## Clients

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

## Invoices

Invoices are used via the [Invoice](https://github.com/marcelog/elixir_freshbooks/blob/master/lib/elixir_freshbooks/invoice.ex) module.

```elixir
alias ElixirFreshbooks.Invoice, as: I
alias ElixirFreshbooks.InvoiceLine, as: L
```

### Creating
```elixir
  # Create a new invoice for the client_id 4422, add one line with the given
  # name, description, unit_cost, and quantity.
  > I.create 4422, "sent", ["note1", "note2", "note3"], [
    L.new("Line Name", "Line Description", 2, 4)
  ]
  %ElixirFreshbooks.Invoice{
    client_id: 4422,
    id: 9932,
    lines: [
      %ElixirFreshbooks.InvoiceLine{
        description: "Line Description",
        name: "Line Name",
        quantity: 4,
        type: "item",
        unit_cost: 2
      }
    ],
    notes: ["note1", "note2", "note3"],
    status: "sent"
  }
```

## Payments

Payments are used via the [Payment](https://github.com/marcelog/elixir_freshbooks/blob/master/lib/elixir_freshbooks/Payment.ex) module.

```elixir
alias ElixirFreshbooks.Payment, as: P
```

### Creating
```elixir
  > P.create 889, 10.50, "Credit Card", ["note1", "note2", "note3"]
  %ElixirFreshbooks.Payment{
    invoice_id: 889,
    amount: 10.50,
    id: 778,
    notes: ["note1", "note2", "note3"],
    type: "Credit Card"
  }
```

## Expenses

Expenses are used via the [Expense](https://github.com/marcelog/elixir_freshbooks/blob/master/lib/elixir_freshbooks/Expense.ex) module.

```elixir
alias ElixirFreshbooks.Expense, as: E
```

### Creating
```elixir
  > E.create 1, 1994955, 1.23, "test vendor", ["note1", "note2"]
  %ElixirFreshbooks.Expense{
    amount: 1.23,
    category_id: 1994955,
    client_id: nil,
    date: "2015-12-06",
    id: 320343,
    notes: ["note1", "note2"],
    project_id: nil,
    staff_id: 1,
    vendor: "test vendor"
  }
```
----

# License
The source code is released under Apache 2 License.

Check [LICENSE](https://github.com/marcelog/elixir_freshbooks/blob/master/LICENSE) file for more information.
