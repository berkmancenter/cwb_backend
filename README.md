The back-end Rails application for the Curators Workbench.

## Installing

It's recommended to install the front and back-end FWB applications in sibling directories named `fwb_frontend` and `fwb_backend`. For example:

		git clone git@github.com:berkmancenter/fwb_frontend.git /system/code/fwb_frontend
		git clone git@github.com:berkmancenter/fwb_backend.git /system/code/fwb_backend

After cloning the project, move into the project folder and run `bundle install`.

Create `database.yml` and `rdf_database.yml` files in the `config` directory, using the existing `*.example` files as a reference.

If you haven't already, you'll need to [install and setup mysql](http://dev.mysql.com/doc/).

Then setup the app's mysql databases with:

		bundle exec rake db:create db:migrate

Populate your database with a few development accounts (watch the output to view the usernames and passwords):

		bundle exec rake db:seed

You'll then need to install the following (examples below use Homebrew):

		brew install 4store
		brew install imagemagick
		brew install redis

If you're not using OS X and Homebrew, please reference the project-specific docs below:

- [4store](http://4store.org/trac/wiki/Download)
- [ImageMagick](http://www.imagemagick.org/script/binary-releases.php)
- [Redis](http://redis.io/download)

After installing, setup your 4store database:

		4s-backend-setup fwb
		4s-backend fwb

## Running

Make sure 4store is running:

		4s-httpd -p 8890 fwb

Note: if you want to watch 4store's output pass the "-D" flag on the 4s-httdp command.

Start redis (OS X only, reference redis docs for other OS):

		sudo redis-server /usr/local/etc/redis.conf

Get sidekiq running:

		bundle exec sidekiq

In order to run the FWB application, you need to build the front-end Sproutcore app into the back-end Rails app and then run the Rails app.

From the Sproutcore app directory:

		sproutcore build fwb --buildroot ../fwb_backend/public

Then back in your rails app, start the server:

		bundle exec rails s

You'll find it running at [http://localhost:3000](http://localhost:3000).

## Data

The data associated with accounts, profiles, and tagging history is stored in mysql, while the rest of the your app's data will be stored in 4store.

To reset your mysql database, run:

		bundle exec rake db:reset

Note: This will remove any existing data and then populate your database using the db/seeds.rb file.

To reset your 4store database:

		4s-backend-destroy fwb
		4s-backend-setup fwb
		4s-backend fwb

Note: This will remove any existing data.

## Monitoring

When running on a server it's generally recommended to monitor proecess like Sidekiq and Redis to ensure they're running properly. There are several tools available that can do this for you, including:

- [monit](https://bitbucket.org/tildeslash/monit/)
- [god](https://github.com/mojombo/god)
- [inspeqtor](https://github.com/mperham/inspeqtor)

Instructions on installing and using these tools can be found on their respective sites, and the Sidekiq wiki contains a section dedicated to [monitoring](https://github.com/mperham/sidekiq/wiki/Monitoring) that contains more helpful info.
