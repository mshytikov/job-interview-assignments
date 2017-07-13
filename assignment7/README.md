### Assignment 7

#### Description

For an online advertising company, you are asked to create an application which picks banners for their advertising campaigns.
Saturation is a nono, so we definitely want to avoid that the visitor will see the same banners too often.

So you are given the following business requirements:

* For every campaign, we want 2 banner-picking-mechanisms:
 - Random: Picking available banners randomly with equal chance.  
 - Weighted: The user is allowed to pick which banner will be displayed, and at which ratio.
   (E.g BannerA: 3, BannerB: 2, BannerC: 1 etc)
   
* We want to allow the user to set a ratio between these 2 banner-picking-mechanisms.
  So let’s say, if the user sets 30% Random 70% Weighted, then when a request comes in (frontend),
  there is a 30% chance that it will pick Random, 70% chance it will use Weighted.

* The visitor should not see the same banner again until he has seen all other banners in that campaign.

* In the backend, you should also allow the user to “weight” banners (set ratios, see above) within a campaign.
 

*Technical requirements*:

* We hate database calls as it makes our requests slow. So eliminate them as much as you can.
* It needs to be able to serve 5000 requests per minute (or more) and benchmark results must be provided
* Test coverage
* Deploy it to Heroku or VPS
* Pushed to GitHub
 
It is up to you to decide, which objects you want to cache, which type of dataset, how to expire etc.
Also the tool for the job is completely up to you. We have attached a folder with images for you, which you can serve as
your banners.  We expect you to explain clearly (in english) why you have chosen for a
certain way to tackle this problem, why you have chosen for a specific tool etc.

Bonus points:
* Any algorithms / mechanisms you can think of to avoid saturation
* Able to serve a lot more than 5000 request per minute


#### Analysis

According to the requirements it is better to have 2 services:
 1. *AdMin* - this service should store all sensitive data and provide Web interface for its management. 
    It is administrative service accessible to user.

 2. *AdServe* - this service should return links to the banners and accordingly store visitors data.
    It is public service accessible to visitors

*To keep a simple solution* were decided to use components described bellow. 
NOTE: Here is not described all the reasons 'why this tool?' because all
of them already described on internet.

*AdMin* it should not be a 'high performance' service but it should
be flexible and extendable:

 1. Nginx - as a Reverse proxy.
    It always nice to have something on front of the App to add additional
    functionality without touching the App like serving https etc., as
    example it will also will be used for serving static banners images.

 2. Unicorn - as a HTTP server.
    It could be also Puma, Thin, etc
    But it's easy to switch to Rainbows if needed
     
 3. Rails - as an Application framework
    Because it is easily extendable. For the current solution the only
    CRUD for banners and campaigns needed but in general additional
    functionality like account management, billing etc, could be added easily.

 4. SQLite as a Database layer
    Just to keep the solution simple.


*AdServe* - it should be a 'high performance' service and probably 
probably horizontally scalable, but the focus for this assignment is a
performance.

 1. Puma - as a HTTP server.
    To have a speed and minimize the memory consumption

 2. Sinatra - as an Application framework.
    Because we need here really thin and simple framework.

 3. Redis as a Database layer
    Fast in-memory database with persistence ability and also supports
    some data types - exactly what is needed!


*API*

The communication between AdMin and AdServer shuld be done using HTTP
protocol.
The AdServe should have API like:

Private API accessible for AdMin

```
# Create of Update the banner
# returns 201 on create and 204 on update
PUT    /campaigns/:id

# To delete the compaign
# returns 204
DELETE /campaigns/:id

# The same concept for banners
PUT    /campaigns/:id/banners/:id
DELETE /campaigns/:id/banners/:id
```

Public API accessible for Visitors

```
# returns 302 redirect to the banner image
GET /banner/:campaing_id/:user_id
```

*Data*

For simplicity banners will be uploaded and stored on *AdMin* server
and served by Nginx as a static content.

The most interesting part is organisation of data storage in the Redis:

Campaign will be stored in:

```
campaign:<id>:ratio   => {random => 3, weighted=7}
campaign:<id>:banner:<id> => { url => 'banner_url', :index => 12}
campaign:<id>:weights => { <banner_index> => banner_weight, ... }
campaign:<id>:banners => { <banner_index> => banner_id, ... }
```
The `<banner_index>` is a index of the banner needed to support user
state described below.

User state will be stored in:

```
campaigns:<id>:user:<uid> => "00010101000111001"
```

The key which stores bitmask of banners which were already shown to user.
This is most efficient way to minimize memory consumption. One bit per
banner to indicate is that banner was shown.
Because of assumption that server should handle at least a million visitors 
is better to use very short key name to save a memory.


*Deployment*

The easiest way it is just use Heroku ...
But it is not what I'm interesting in.
I decided to relax the testing of the AdMin app in favor of Deployment, (because
the AdMin will have straightforward implementation also keep in mind
that this is a TEST assignment and not production ready product
(I can find 100 more excuses which are not excuses)
Deployment will be done using Chef.


#### Let's start with implementation !!!
.
.
.
.
.

### Instalation

Was developed and tested using ruby 1.9.3 and 2.1, SQLlite 3.7.17, Redis 2.8.6 

See sub-projects `README` files for more information.


Install dependencies

``` 
bundle install

sh -c 'cd ad_serve && bundle install'
sh -c 'cd ad_min && bundle install'
```

Create DB

```
redis-cli flushdb
sh -c 'cd ad_min && bundle exec rake db:create'
sh -c 'cd ad_min && bundle exec rake db:migrate'
```

Start services
```
foreman start
```


Seed Data
```
sh -c 'cd ad_min && bundle exec rake db:seed'
```

AdMin url   [http://localhost:3000](http://localhost:3000)
AdServe url [http://localhost:3001/campaigns/1/users/1/next_banner](http://localhost:3001/campaigns/1/users/1/next_banner)


### Tests

Run tests
```
sh -c 'cd ad_min   && bundle exec rake'
sh -c 'cd ad_serve && bundle exec rake'
```


## Deployed examples:
AdMin: [http://ad-min.herokuapp.com](http://ad-min.herokuapp.com)

AdServe: [http://ad-serve.herokuapp.com](http://ad-serve.herokuapp.com/campaigns/1/users/1/next_banner)

Url for testing ```http://ad-serve.herokuapp.com/campaigns/:campaign_id/users/:user_id/next_banner```

Page for testing : [http://ad-min.herokuapp.com](http://ad-min.herokuapp.com/test.html)

### Some test results

```
ab -k -n 500 -c 10
http://ad-serve.herokuapp.com/campaigns/1/users/567/next_banner
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking ad-serve.herokuapp.com (be patient)

Server Software:        
Server Hostname:        ad-serve.herokuapp.com
Server Port:            80

Document Path:          /campaigns/1/users/567/next_banner
Document Length:        0 bytes

Concurrency Level:      10
Time taken for tests:   6.864 seconds
Complete requests:      500
Failed requests:        0
Write errors:           0
Non-2xx responses:      500
Keep-Alive requests:    500
Total transferred:      136609 bytes
HTML transferred:       0 bytes
Requests per second:    72.85 [#/sec] (mean)
Time per request:       137.270 [ms] (mean)
Time per request:       13.727 [ms] (mean, across all concurrent
requests)
Transfer rate:          19.44 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   4.9      0      43
Processing:    38  136  36.5    147     215
Waiting:       38  136  36.5    147     215
Total:         38  136  37.0    148     215

```


P.S.: Known bugs - a lot of them )))) because it is **test** assignment. The
deletion for campaign does not work because default redis version on
Heroku < 2.6.0.


