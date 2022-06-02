# Hivekind Software Engineering Talent Test

Welcome to the Hivekind Software Engineering Talent Test!

In this test, we ask you to make three changes to a working web application. These changes will be solutions to three open items from the web application's project backlog.

The source code of the web application is located in this Git repository. You can run the application using Vagrant. Indeed, for this test we expect you to be familiar with [git][1], [Vagrant][2] and [VirtualBox][3]. The provisioning facility of Vagrant will give you a box with the necessary software to get you started.

## Project Concept

The application that you'll work on is a fictitious product that we recently launched called LinkHive. LinkHive is a classic URL shortener with analytics. Users can provide a (long) URL and they will be given the shortened URL that they can use on emails or instant messages. The shortened link includes analytics, tracking how many times the link was visited and from which location. The analytics page provides historical information about the link performance as well as realtime tracking of incoming clicks.

The application's MVP launch was considered a success, but success comes with its own price. Immediately after launch we were flooded with feature requests, bug reports, UI tweaks requests, and performance issues. Below you will find a list, in no particular order, of the most important items on LinkHive's backlog.

## Getting Started

After starting the virtual machine with `vagrant up`, start the rails application with `vagrant ssh -c 'cd app && foreman start'`.

The Web UI for the application can be reached at http://localhost:3000

The API endpoints are at http://localhost:3000/api/.. (example: http://localhost:3000/api/urls/hk) and on development you can authenticate following the [How to interact with the API](docs/Runbook.md#how-to-interact-with-the-api) section of the Runbook.

## Your Assignment

Please provide a solution to three backlog items of your choice. For each item, please create a merge request that resolves it. You can commit and push as many times as you want. Note that the backlog contains more than three items - you are free to provide solutions to more than three, but this isn't required.

You may use any gem or package you want, but please make sure that the rest of the application still works as intended without any major deviations (avoid changes like requiring a lower version of Ruby, for example).

Please update the Vagrant provisioner if your solution requires extra packages, database schema changes, code/dependencies initialization or service startup. `vagrant up` should bring a fresh clone into working state (refer to the `Instructions` section).

### Backlog items

* [Slow-Redirection](docs/Slow-Redirection.md)
* [Slow-Homepage](docs/Slow-Homepage.md)
* [Responsive-Layout](docs/Responsive-Layout.md)
* [Link-Manager](docs/Link-Manager.md)
* [Realtime-Graphs](docs/Realtime-Graphs.md)
* [GeoIP-Maps](docs/GeoIP-Maps.md)
* [Url-Generation](docs/Url-Generation.md)
* [Infinite-Scroll](docs/Infinite-Scroll.md)

# Evaluation

Your response will be pre-evaluated by an automated system by doing:

* `git clone <this repository url>`
* `vagrant up --provision`
* `vagrant ssh -c 'cd app && bin/rake'`
* `vagrant ssh -c 'cd app && foreman start'`
* run additional automated smoke tests against the web interface, the api and the database.

Ensure those steps work as you would expect before asking for your answer to be evaluated.

Once you are sure that these steps work, please let us know you’re ready to be assessed by replying to the email which brought you to the test in the first place (typically sent from careers@hivekind.com).

## FAQ

### This code/setup doesn't work for me.

It is expected at least passing familiarity with Virtual Machines and Vagrant. We don't provide support on setting up your development machine. The virtual environment provided has all the dependencies and configurations necessary and works out of the box *inside the VM*. Your submitted solution is expected to work *inside the VM* too, including running of the tests.

You can find some documentation on setting up the project and using vagrant in the [Runbook](docs/Runbook.md)

### Why Vagrant and not Docker?

While we use Docker regularly for development, we find that the user experience can be quite different depending on whether you are running Linux, Mac, or Windows. For consistency sake, we chose to provide this talent test in Vagrant.

If you look closely at the repository you will notice it includes a `Dockerfile` and a `docker-compose.yml` files for convenience. While we expect they should work, there is no guarantee or support for them. Your solution will *always* be evaluated using Vagrant.

[1]: http://git-scm.com/
[2]: https://www.vagrantup.com/
[3]: https://www.virtualbox.org/
