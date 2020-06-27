# Expose your PostgreSQL data with a GraphQL API

> This is a POC of how to run a GraphQL API to expose data from a PostreSQL Database.

## About

This POC contains a relational database that represents a ledger with `users` and `transactions`. 

```
CREATE DATABASE ledger;
\connect ledger;
CREATE SCHEMA ledger_schema;
CREATE TABLE ledger_schema.users (
    id SERIAL PRIMARY KEY,
    name TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE ledger_schema.users IS
'User information.';
CREATE TABLE ledger_schema.transactions (
    id SERIAL PRIMARY KEY,
    amount INTEGER NOT NULL,
    description TEXT,
    user_from_id INTEGER NOT NULL REFERENCES ledger_schema.users(id),
    user_to_id INTEGER NOT NULL REFERENCES ledger_schema.users(id),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE ledger_schema.transactions IS
'Transactions for all users.';
```

This is the initial data:

```
\connect ledger;
INSERT INTO ledger_schema.users (name) VALUES
('Alfonso'),
('Juan');
INSERT INTO ledger_schema.transactions (amount, description, user_from_id, user_to_id) VALUES
(15000, 'Consulting Services', 1, 2),
(12000, 'Consulting Services', 1, 2),
(10000, 'Ad Campaign', 2, 1);
```

# Running the project


## Dependencies

1- Make sure you have `docker` and `docker-compose` installed on your machine.

2- Then make sure you have `postgraphile` installed. If not, then run 

    $ npm install -g postgraphile

## Getting Started

Run

```
docker-compose up
```
Open http://0.0.0.0:5000/graphiql in your browser


![Alt text](/graphql.png?raw=true "Optional Title")

You can now start querying and inserting data by using Queries and mutations.

# Queries and mutations

## Query examples

Query all users **name** and **amount** of the transactions he made: 
```
query {
  allUsers {
    nodes {
      name
      transactionsByUserFromId {
        nodes {
          amount
        }
      }
    }
  }
}
```
Result:
```
{
  "data": {
    "allUsers": {
      "nodes": [
        {
          "name": "Alfonso",
          "transactionsByUserFromId": {
            "nodes": [
              {
                "amount": 15000
              },
              {
                "amount": 12000
              }
            ]
          }
        },
        {
          "name": "Juan",
          "transactionsByUserFromId": {
            "nodes": [
              {
                "amount": 10000
              }
            ]
          }
        }
      ]
    }
  }
}
```

Query all users **name** and its **date** of creation
```
query {
  allUsers {
    nodes {
      name
      createdDate
    }
  }
}
```

Result: 
```
{
  "data": {
    "allUsers": {
      "nodes": [
        {
          "name": "Alfonso",
          "createdDate": "2020-06-27T21:56:01.66932"
        },
        {
          "name": "Juan",
          "createdDate": "2020-06-27T21:56:01.66932"
        }
      ]
    }
  }
}
```

## Mutation examples

Create an user named `Pedro` and return its Id and Name:

```
mutation {
  createUser(
    input: {
      user: {
        name: "Pedro"
      }
    }
  ) {
    user {
      id
      name
    }
  }
}
```

Result (user created):
```
{
  "data": {
    "createUser": {
      "user": {
        "id": 3,
        "name": "Pedro"
      }
    }
  }
}
```

Create a transaction from Pedro to Alfonso:

```
mutation {
  createTransaction(
    input: {
      transaction: {
        amount: 5000,
        userFromId: 3,
        userToId: 1
      }
    }
  ) {
    transaction {
      id
      amount
      userFromId
      userToId
    }
  }
}
```

Result (transaction created)

```
{
  "data": {
    "createTransaction": {
      "transaction": {
        "id": 4,
        "amount": 5000,
        "userFromId": 3,
        "userToId": 1
      }
    }
  }
}
```
