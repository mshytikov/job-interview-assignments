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
