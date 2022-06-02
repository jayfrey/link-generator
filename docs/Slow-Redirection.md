Scenario: Improve url redirection performance when under heavy load

Description: We didn't realize it during our pre-launch testing, but when our Social Networking Services (SNS) team posted an article on linkedin, we got more traffic than ever before and found out that redirection is slow for the most visited urls.

We've prepared a benchmark to test this out. First reset and seed the test database with urls and slugs:

```
vagrant@ubuntu2004:~/app$ time RAILS_ENV=test bundle exec rails db:reset benchmark=true
Dropped database 'talent_test_dev_test'
Created database 'talent_test_dev_test'
trying to insert 1000000 urls in the database
generating urls 1 of 10
generating urls |Time: 00:00:17 | ================================================================================= | Time: 00:00:17
inserting 100000 records into the database
generating urls 2 of 10
generating urls |Time: 00:00:17 | ================================================================================= | Time: 00:00:17
inserting 100000 records into the database
generating urls 3 of 10
generating urls |Time: 00:00:17 | ================================================================================= | Time: 00:00:17
inserting 100000 records into the database
generating urls 4 of 10
generating urls |Time: 00:00:18 | ================================================================================= | Time: 00:00:18
inserting 100000 records into the database
generating urls 5 of 10
generating urls |Time: 00:00:18 | ================================================================================= | Time: 00:00:18
inserting 100000 records into the database
generating urls 6 of 10
generating urls |Time: 00:00:18 | ================================================================================= | Time: 00:00:18
inserting 100000 records into the database
generating urls 7 of 10
generating urls |Time: 00:00:18 | ================================================================================= | Time: 00:00:18
inserting 100000 records into the database
generating urls 8 of 10
generating urls |Time: 00:00:17 | ================================================================================= | Time: 00:00:17
inserting 100000 records into the database
generating urls 9 of 10
generating urls |Time: 00:00:18 | ================================================================================= | Time: 00:00:18
inserting 100000 records into the database
generating urls 10 of 10
generating urls |Time: 00:00:17 | ================================================================================= | Time: 00:00:17
inserting 100000 records into the database

real    4m36.836s
user    5m33.089s
sys     3m19.564s
```

Then prepare the siege urls:

```
vagrant@ubuntu2004:~/app$ RAILS_ENV=benchmark bundle exec rails benchmark:slow_redirection:prepare
RAILS_ENV=benchmark environment is not defined in config/webpacker.yml, falling back to production environment
generating siege urls
done generating urls in /tmp/slow_redirection.txt
```

You can now run the benchmark itself:

```
vagrant@ubuntu2004:~/app$ RAILS_ENV=benchmark bundle exec rails benchmark:slow_redirection:run
RAILS_ENV=benchmark environment is not defined in config/webpacker.yml, falling back to production environment
running the benchmarking server
done, server pid is 38264
running benchmark for 5 minutes:
** SIEGE 4.0.4
** Preparing 100 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:                   4686 hits
Availability:                 100.00 %
Elapsed time:                 299.23 secs
Data transferred:               0.43 MB
Response time:                  6.31 secs
Transaction rate:              15.66 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                   98.86
Successful transactions:        4686
Failed transactions:               0
Longest transaction:            7.33
Shortest transaction:           0.46


killing test server
all done
```

```
Started GET "/o/rrsoft" for 127.0.0.1 at 2021-06-17 08:25:56 +0000
Processing by LinksController#visit as */*
  Parameters: {"slug"=>"rrsoft"}
  Url Load (1.5ms)  SELECT "urls".* FROM "urls" WHERE "urls"."slug" = $1 LIMIT $2  [["slug", "rrsoft"], ["LIMIT", 1]]
  TRANSACTION (0.5ms)  BEGIN
  Statistic Create (1.1ms)  INSERT INTO "statistics" ("user_agent", "ip", "country", "created_at", "updated_at", "url_id") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["user_agent", "Mozilla/5.0 (pc-x86_64-linux-gnu) Siege/4.0.4"], ["ip", "127.0.0.1"], ["country", "unknown"], ["created_at", "2021-06-17 08:25:56.562447"], ["updated_at", "2021-06-17 08:25:56.562447"], ["url_id", 3001]]
  TRANSACTION (1.3ms)  COMMIT
   (1.3ms)  SELECT COUNT(*) FROM "statistics" WHERE "statistics"."url_id" = $1  [["url_id", 3001]]
[ActionCable] Broadcasting to url_visit:rrsoft: "{\"id\":243718,\"user_agent\":\"Mozilla/5.0 (pc-x86_64-linux-gnu) Siege/4.0.4\",\"referrer\":null,\"ip\":\"127.0.0.1\",\"country\":\"unknown\",\"created_at\":\"2021-06-17T08:25:56.562Z\",\"count\":100}"
Redirected to https://rrsoft.co
Completed 302 Found in 80ms (ActiveRecord: 5.7ms | Allocations: 2050)
```

We'd like to improve the transaction rate by at least 20% of what it currently is. We know that your local development machine might be faster or slower than our test machines, so we're only looking for relative improvements.
