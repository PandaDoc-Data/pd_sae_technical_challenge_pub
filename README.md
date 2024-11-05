# Senior Analytics Engineer Assignment

## Introduction
This assignment is part of the recruitment process for Analytics Engineers here at PandaDoc. Its purpose is to assess the technical skills of our candidates in a generic scenario, similar to the one they would experience at PandaDoc.

Please carefully read all of the instructions before starting to work on your solution and feel free to contact us if you have any issues or questions.

## Source Data
You will be working with a dataset of events from an online store collected from a Customer Data Platform. It has been previously loaded and cleaned and is stored in a table called `event_clean`, with the following structure:

* `event_time`: Date and time when the event happened at (in UTC)
* `event_type`: Type of behavioral event
* `product_id`: Unique numeric identifier of a product
* `category_id`: Unique numeric identifier of the category of a product
* `category_code`: Text identifier of the category of a product
* `brand`: Text identifier of the brand of a product
* `price`: Price of a product
* `user_id`: Unique numeric identifier of a user
* `user_session`: Unique UUID identifier of a user session

The dataset contains 4 types of behavioral events, defined as follows:
* `view`: A user viewed a product
* `cart`: A user added a product to the shopping cart
* `remove_from_cart`: A user removed a product from the shopping cart
* `purchase`: A user purchased a product

The sample dataset consists of data for January and February 2020.

## Assignment
The overall objective of the assignment is to create a series of tables with aggregated data for analytical purposes. We have divided the challenge into several tasks.

Please perform all work using dbt and submit a pull request with your work, so that we can see and review your work.

### Task 1: Daily Sales
First, we'd like you to calculate the aggregated sales per day. The output should be a `daily_sales` table in the following format:

| DATE | TOTAL_SALES |
|------|-------------|
| 2020-01-01 | 1000 |
| ... | ... |

### Task 2: Daily Stats of Visitors, Sessions, Viewers, Views, Leaders, Leads, Purchasers & Purchases
Now we'd like you to calculate the daily stats for the following metrics:
* visitors: Number of different users that have visited the store
* sessions: Number of different user sessions for the users that have visited the store
* viewers: Number of different users that have viewed at least one item
* views: Total number of products viewed
* leaders: Number of different users that have added at least one item to the cart
* leads: Total number of products added to the cart
* purchasers: Number of different users that have purchased at least one item
* purchases: Total number of products purchased

The output should be a `daily_stats` table in the following format:

| DATE | VISITORS | SESSIONS | VIEWERS | VIEWS | LEADERS | LEADS | PURCHASERS | PURCHASES |
|------|----------|-----------|----------|--------|----------|--------|------------|------------|
| 2020-01-01 | 1000 | 1250 | 950 | 1125 | 750 | 825 | 250 | 500 |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

### Task 3: Daily Conversion Funnel
Building on the previous insights, now we'd like you to determine the daily conversion funnel. For that, we want to know the ratio of users that make it from one step to the next along the whole journey.

We consider the user journey to be the following steps:
`visitor -> viewer -> leader -> purchaser`

The output should be a `daily_funnel` table in the following format:

| DATE | VISITORS | VIEWERS | LEADERS | PURCHASERS | VISITOR_TO_VIEWER | VIEWER_TO_LEADER | LEADER_TO_PURCHASER |
|------|----------|----------|----------|------------|------------------|------------------|-------------------|
| 2020-01-01 | 1000 | 950 | 750 | 250 | 0.95 | 0.79 | 0.33 |
| ... | ... | ... | ... | ... | ... | ... | ... |

### Task 4: Daily Ticket Size
Finally, we'd like to understand what the distribution of the purchase or ticket size is per user daily. For that, we consider that all the items purchased by a user during one session to belong to the same purchase or ticket. We'd like you to calculate some basic statistics (min, max and 25th, 50th and 75th percentiles) about the ticket size to estimate its distribution.

The output should be a `daily_ticket` table in the following format:

| DATE | TOTAL_SALES | MIN_TICKET | 25TH_PERC_TICKET | 50TH_PERC_TICKET | 75TH_PERC_TICKET | MAX_TICKET |
|------|-------------|------------|------------------|------------------|------------------|------------|
| 2020-01-01 | 1000 | 1.25 | 2.50 | 10.35 | 25.50 | 150.25 |
| ... | ... | ... | ... | ... | ... | ... |

## Snowflake Access

You should be able to access a test Snowflake environment with the following credentials:

* URL: `https://<account>.snowflakecomputing.com` - Provided by recruiter
* Username: `TEST<x>`, where `x` is a number, provided by your recruiter, e.g. `TEST4`
* Password: Provided by recruiter

When logging in, you will want to switch from the `PUBLIC` role to `ROLE<x>` to have the correct permissions.

Please use the `TEST_WH` warehouse for all SQL operations.

You can use the following `profiles.yml` as a template (official documentation [here](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)):

```yaml
pd_saw_technical_challenge:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: [account id]

      # User/password auth
      user: [username]
      password: [password]

      role: [user role]
      database: [database name]
      warehouse: [warehouse name]
      schema: [dbt schema]
      threads: [1 or more]
      client_session_keep_alive: False
```

The `event_clean` table can be found in `DB<x>.ANALYTICS`. Please create all of the above tables in the same database and schema.

If you have any questions about access or permissions, please contact the recruiter.

Good luck! Please do not spend more than about two hours total on this assignment.


## Local Environment Setup

Pre-requisites:
- Python 3.8+ 
  - We recommend using a package manager to manage python versions (e.g. `brew`)
- If on Windows, use WSL2 or a Linux VM

1. Create virtual environment
    - `python3 -m venv .venv`
2. Activate virtual environment
    - `source .venv/bin/activate`
3. Install dependencies
    - `pip install -r requirements.txt`
4. Verify dbt installation
    - `dbt --version`
5. Fill out the profile information in `profiles.yml` using the information from above
    - Recruiter should have provided you with credentials.
6. Verify connection to Snowflake
    - `dbt debug`