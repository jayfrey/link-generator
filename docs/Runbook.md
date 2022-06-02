## How to run Vagrant

Virtualbox is a prerequisite for vagrant; you can get it from the [Virtualbox download page](https://www.virtualbox.org/wiki/Downloads).

You will then need to download and install vagrant for your operating system, then after cloning the repository you can start vagrant via `vagrant up` and it will automatically create and provision the development virtual machine for you.

It takes a couple of minutes for the initial provisioning, but subsequent invocations take only a few seconds (the time it takes for the virtual machine to boot up).

Here is an example log:

```
user@machine$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'hk-ubuntu' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Box file was not detected as metadata. Adding it directly...
==> default: Adding box 'hk-ubuntu' (v0) for provider: virtualbox
    default: Downloading: https://f99887ee-65bc-46ea-be13-64517d761b27.s3.ap-southeast-1.amazonaws.com/talent-test-ubuntu-v1.box
    default: Calculating and comparing box checksum...
==> default: Successfully added box 'hk-ubuntu' (v0) for 'virtualbox'!
==> default: Importing base box 'hk-ubuntu'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: tt-user_default_1649959941743_17072
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 3000 (guest) => 3000 (host) (adapter 1)
    default: 3035 (guest) => 3035 (host) (adapter 1)
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /home/vagrant/app => /home/user/tt-user
==> default: Running provisioner: shell...
    default: Running: /tmp/vagrant-shell20210531-71681-1idx6nj
...
    default: Hit:1 http://us.archive.ubuntu.com/ubuntu focal InRelease
    default: Get:2 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
    default: Get:3 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease [101 kB]
    default: Get:4 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [991 kB]
    default: Get:5 http://us.archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [482 kB]
...
...
...
    default: Using web-console 4.1.0
    default: Using webpacker 5.3.0
    default: Bundle complete! 29 Gemfile dependencies, 118 gems now installed.
    default: Bundled gems are installed into `./vendor/bundle`
    default: Bundle complete! 29 Gemfile dependencies, 118 gems now installed.
    default: Bundled gems are installed into `./vendor/bundle`
    default: Database 'talent_test_dev_development' already exists
    default: Database 'talent_test_dev_test' already exists
    default: generating urls: |=============================================================|
    default: + cat
```

## How to access the Vagrant Virtual Machine for development

After starting the development vm via `vagrant up` it will automatically do the following:

* mount the current folder to the vm's `/home/vagrant/app` folder
* install ruby and nodejs
* install gems and node packages
* create the development and test db
* generate seed urls and statistics

That means that any changes you make to files will automatically be reflected in the development machine, and since rails is running in development mode it will automatically detect file changes and adapt accordingly.

You can ssh into the virtual machine using `vagrant ssh`.
You can start the application by running `foreman start -d ~/app` inside the virtual machine.

## How to view the logs (development, benchmark, etc)

Rails logs will be stored in `log/development.log`

Example output:

``` sql
vagrant@ubuntu2004:~/app$ tail -f log/development.log
  TRANSACTION (1.0ms)  COMMIT
  ActiveRecord::InternalMetadata Load (0.4ms)  SELECT "ar_internal_metadata".* FROM "ar_internal_metadata" WHERE "ar_internal_metadata"."key" = $1 LIMIT $2  [["key", "environment"], ["LIMIT", 1]]
  TRANSACTION (0.2ms)  BEGIN
  ActiveRecord::InternalMetadata Update (0.4ms)  UPDATE "ar_internal_metadata" SET "value" = $1, "updated_at" = $2 WHERE "ar_internal_metadata"."key" = $3  [["value", "test"], ["updated_at", "2021-06-02 08:40:55.583963"], ["key", "environment"]]
  TRANSACTION (1.1ms)  COMMIT
  ActiveRecord::InternalMetadata Load (0.3ms)  SELECT "ar_internal_metadata".* FROM "ar_internal_metadata" WHERE "ar_internal_metadata"."key" = $1 LIMIT $2  [["key", "schema_sha1"], ["LIMIT", 1]]
  TRANSACTION (0.2ms)  BEGIN
  ActiveRecord::InternalMetadata Create (0.3ms)  INSERT INTO "ar_internal_metadata" ("key", "value", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "key"  [["key", "schema_sha1"], ["value", "32bc94c87bcbffd4719fcac41169c7eff478fad8"], ["created_at", "2021-06-02 08:40:55.591838"], ["updated_at", "2021-06-02 08:40:55.591838"]]
  TRANSACTION (1.0ms)  COMMIT
   (0.5ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
Started GET "/" for 10.0.2.2 at 2021-06-02 08:51:45 +0000
Cannot render console from 10.0.2.2! Allowed networks: 127.0.0.0/127.255.255.255, ::1
Processing by HomepageController#index as HTML
  Rendering layout layouts/application.html.erb
  Rendering homepage/index.html.erb within layouts/application
  Rendered homepage/index.html.erb within layouts/application (Duration: 0.1ms | Allocations: 36)
[Webpacker] Compiling...
[Webpacker] Compiled all packs in /home/vagrant/app/public/packs
[Webpacker] Though the "loose" option was set to "false" in your @babel/preset-env config, it will not be used for @babel/plugin-proposal-private-methods since the "loose" mode option was set to "true" for @babel/plugin-proposal-class-properties.
The "loose" option must be the same for @babel/plugin-proposal-class-properties, @babel/plugin-proposal-private-methods and @babel/plugin-proposal-private-property-in-object (when they are enabled): you can silence this warning by explicitly adding
        ["@babel/plugin-proposal-private-methods", { "loose": true }]
to the "plugins" section of your Babel config.

[Webpacker] Hash: 51ca4947d10153179be7
Version: webpack 4.46.0
Time: 5379ms
Built at: 06/02/2021 8:51:57 AM
                                     Asset      Size       Chunks                         Chunk Names
          js/Index-ddb1aaa97ae69e2798aa.js  2.57 MiB        Index  [emitted] [immutable]  Index
      js/Index-ddb1aaa97ae69e2798aa.js.map   2.8 MiB        Index  [emitted] [dev]        Index
.
.
.
Completed 200 OK in 119ms (Views: 21.3ms | ActiveRecord: 31.0ms | Allocations: 80342)
```

## How to run a rails console

Start by ssh-ing into the VM with `vagrant ssh` then run `cd app; bin/rails console`

```
vagrant@ubuntu2004:~/app$ bin/rails c
Running via Spring preloader in process 35518
Loading development environment (Rails 6.1.3.2)
irb: warn: can't alias context from irb_context.
3.0.0 :001 >
```

## How to interact with the API

We are using oauth as our authentication mechanism. For development, we are using the oauth developer strategy, which is found at `/auth/developer`.

Start by visiting the `/auth/developer` url. After filling in the name and email fields, you will be redirected to the previous url with a query parameter called `session_id` like so:

```
http://localhost:3000/?session_id=2592ca4d984b57f0094bfb99b9b5ec0c
```

Most of the apis are available without having to be authenticated; however if you want to generate an authenticated request, attach the query parameter `session_id` to the api url like so:

```
http://localhost:3000/api/urls/new?session_id=2592ca4d984b57f0094bfb99b9b5ec0c
```

In the rails app, you will now have the `current_user` helper method returning the current logged in user.

You can also access details of the current user by sending an authenticated request to `/api/users/whoami`

This whole workflow is also captured in the system spec `spec/system/login_spec.rb`:

``` ruby
it "logs in and uses the returned token to retrieve session info" do
  visit "/auth/developer"

  fill_in "Name", with: "rspec"
  fill_in "Email", with: "rspec@example.com"
  click_button "Sign In"

  expect(current_url).to include("session_id")

  session_id = URI(current_url).query.split("=")[1]
  visit "/api/users/whoami?session_id=#{session_id}"

  expect(page).to have_text("rspec@example.com")
end
```

## How to run the specs

We use rspec as our test harness. These are located in the `/spec` folder.

You can run the test if you `vagrant ssh` to the development machine, change into the `app` folder, and run `bundle exec rspec`:

``` bash
$ vagrant ssh
Last login: Wed Oct 21 16:29:00 2015 from 10.0.2.2
```
``` bash
vagrant@ubuntu2004:~$ cd app/
vagrant@ubuntu2004:~/app$ bundle exec rspec
.....D, [2021-06-02T18:54:12.256405 #38953] DEBUG -- omniauth: (developer) Request phase initiated.
D, [2021-06-02T18:54:12.384377 #38953] DEBUG -- omniauth: (developer) Callback phase initiated.
..D, [2021-06-02T18:54:28.693408 #38953] DEBUG -- omniauth: (developer) Request phase initiated.
D, [2021-06-02T18:54:28.735539 #38953] DEBUG -- omniauth: (developer) Callback phase initiated.
.D, [2021-06-02T18:54:28.990377 #38953] DEBUG -- omniauth: (developer) Request phase initiated.
D, [2021-06-02T18:54:29.089113 #38953] DEBUG -- omniauth: (developer) Callback phase initiated.
.

Finished in 25.18 seconds (files took 9.81 seconds to load)
9 examples, 0 failures

```
