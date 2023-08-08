# README
--- APPLICATION ACCESS ---

https://damp-river-5317.fly.dev/

Login details:

admin1@test.com - admin1
driver1@test.com - driver1

App info:
Schedules, deliveries and availabilities are populated with data from the 
first week of September.

When first accessing the app online, it make take around 30 secs for it to load. 
This is because the hosting vm switches to standy after long periods of non use. 
This keeps costings and poweruse to a minimum.

--- REPOSITORY OVERVIEW ---
The app/ directory contains the MVC (Model-View-Controller) pattern of the 
application, plus styling and JavaScript.
The config/ directory holds the application's configuration files. In particular, 
the routes with all the applications URL routes and database.yml with the details
for database setup.
The db/ directory contains the database schema and migrations.
The test/ directory holds unit tests and fixtures to load the test data.
Seperately, the Gemfile is used to manage the gems needed to run the application.


--- SETUP ---
This README would normally document whatever steps are necessary to get the
application up and running but it is already accessible 
via https://damp-river-5317.fly.dev/
However, manual setups should follow the below.

* Ruby version:
ruby-3.1.2

* System dependencies:
See package-lock.json, in particular "dependencies" and "devDependencies".
Ensure these packages are installed.

* Configuration:
Once RoR setup on your system and dependencies are installed, run "bundle install" 
in your console to get gems.

* Database creation:
Run "rails db:create"
Run "rails db:migrate"

* Database initialization:
Run "rails db:seed" (Only required if you require app to be pre-populated with data)
Run "rails db:fixtures:load RAILS_ENV=test" (Only required if you are running tests)

* Start the application:
Run "rails s"

* How to run the test suite:
For model unit tests, run "rails test test/models"
For controller unit tests, run 
"rails test test/controllers/**InsertControllerName**_controller_test.rb" 
Controller tests must be run individually due to test suite errors.