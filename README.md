# Moses

This is specialization of David Dollar's [valkyrie](https://github.com/ddollar/valkyrie) gem. It's been modified for the purpose of migrating a SQL Server database to PostgreSQL.

## Assumptions

It assumes an empty PostgreSQL (destination) database with schema that matches the SQL Server (source) database. This can be accomplished in a Rails app by updating its `database.yml` file to point to the Postgres database and running `bundle exec rake db:drop db:create db:schema:load` in whichever environment you want to use.

## Usage

Since this is not a gem but just a set of scripts, you'll need to clone the code to use it:

```
git clone git@github.com:molawson/moses.git
```

Once you have a SQL Server database that you want to migrate to Postgres and an empty Postgres database with the right schema (like described above), you need to create a `database.yml` file in the `config/` directory of this library. There is an existing `config/database.example.yml` file that you can use as a template. Fill out the `database.yml` file with the credientials of your source and destination databases.

Then, from the root directory of this library, run:

```
bundle install
bundle exec ./bin/moses
```

You'll see a progress bar for each table while it's being migrated.
