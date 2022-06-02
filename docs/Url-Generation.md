Scenario: Improve url generation performance when under heavy load

Description: We're in talks with a well-known Social Networking Service, and they would like to sue our link generation api platform as a white-labeled solution (think of twitter's t.co shortening service).

We've been fine with the current load, but we found that performance degrades significantly when dealing with the amount of traffic we're expecting once the SNS starts sending us traffic.

To properly quantify this, we've made a benchmark to measure the amount of time url generation requests would take.

If you haven't prepared the db with the urls, you should do so now (it only takes about 5 minutes):

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

Then, prepare the urls for siege:

```
vagrant@ubuntu2004:~/app$ RAILS_ENV=benchmark bundle exec rails benchmark:url_generation:prepare
RAILS_ENV=benchmark environment is not defined in config/webpacker.yml, falling back to production environment
generating siege urls
done generating urls in /tmp/url_generation.txt
```

From this point on, you will just need to run the benchmark without having to seed the db nor prepare the siege urls:

```
vagrant@ubuntu2004:~/app$ RAILS_ENV=benchmark bundle exec rails benchmark:url_generation:run
RAILS_ENV=benchmark environment is not defined in config/webpacker.yml, falling back to production environment
running the benchmarking server
done, server pid is 7316
running benchmark for 5 minutes:
** SIEGE 4.0.4
** Preparing 100 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:                   5406 hits
Availability:                 100.00 %
Elapsed time:                 299.59 secs
Data transferred:               1.12 MB
Response time:                  5.49 secs
Transaction rate:              18.04 trans/sec
Throughput:                     0.00 MB/sec
Concurrency:                   99.06
Successful transactions:        5406
Failed transactions:               0
Longest transaction:            6.41
Shortest transaction:           0.28


killing test server
all done
```

```
Started POST "/api/urls" for 127.0.0.1 at 2021-06-16 06:20:40 +0000
Processing by Api::UrlsController#create as */*
  Parameters: {"url"=>"https://1265.2307774974881.example.com"}
  Url Load (0.5ms)  SELECT "urls".* FROM "urls" WHERE "urls"."url" = $1 LIMIT $2  [["url", "https://1265.2307774974881.example.com"], ["LIMIT", 1]]
  Url Exists? (0.8ms)  SELECT 1 AS one FROM "urls" WHERE "urls"."slug" = $1 LIMIT $2  [["slug", "hujek9cfp"], ["LIMIT", 1]]
  TRANSACTION (0.7ms)  BEGIN
  Url Create (0.8ms)  INSERT INTO "urls" ("slug", "url", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["slug", "hujek9cfp"], ["url", "https://1265.2307774974881.example.com"], ["created_at", "2021-06-16 06:20:41.049956"], ["updated_at", "2021-06-16 06:20:41.049956"]]
  TRANSACTION (1.0ms)  COMMIT
   (0.5ms)  SELECT COUNT(*) FROM "statistics" WHERE "statistics"."url_id" = $1  [["url_id", 1000]]
Completed 200 OK in 13ms (Views: 1.5ms | ActiveRecord: 4.4ms | Allocations: 1448)
```
