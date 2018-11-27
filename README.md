## Ruby-Rails sample code

This is a sample Rails app.


### Setup the Local Environment

* [Install Ruby on Rails with RVM on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rvm-on-ubuntu-16-04)

```
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

$ cd /tmp

$ curl -sSL https://get.rvm.io -o rvm.sh

$ less /tmp/rvm.sh

$ cat /tmp/rvm.sh | bash -s stable --rails

$ source /home/{username}/.rvm/scripts/rvm

$ rvm install 2.3.1
```

* [Install the latest version of nodejs and npm](https://askubuntu.com/questions/594656/how-to-install-the-latest-versions-of-nodejs-and-npm)

```
$ curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

$ sudo apt-get install -y nodejs
```

* [Install the postgreSQL on ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04)

```
$ sudo apt-get install postgresql postgresql-contrib

$ sudo apt-get install pgadmin3

$ sudo -i -u postgres

$ sudo -u postgres createuser -s dev

$ sudo -u postgres psql
```

NOTE__: Grant the peer authentication to get pgsql working with rails (reference: https://stackoverflow.com/questions/18664074/getting-error-peer-authentication-failed-for-user-postgres-when-trying-to-ge)

```
$ sudo nano /etc/postgresql/9.5/main/pg_hba.conf
```

Need to change the below line. 

```bash
local   all             postgres                                peer
```

```bash
local   all             postgres                                md5
```

```
sudo service postgresql restart
```

* Need to install the postgresql dependencies. 

```
sudo apt-get install libpq-dev
```

### Running Locally

* Make sure you have Ruby, Bundler installed. 

```
$ git clone https://remko93223@bitbucket.org/remko93223/ruby-rails-mvp.git

$ cd ruby-rails-mvp/

$ rvm gemset list

$ gem install bundler

$ bundle install

$ rake db:create

$ rake db:migrate

$ bower install
```

NOTE__: If you encounter in the `bower install`, try to fix the git config in the below. 


```
$ git config --global --unset http.proxy

$ git config --global --unset https.proxy

$ bower install
```

* To run the server on localhost:3000. 

```
$ rails s
```
