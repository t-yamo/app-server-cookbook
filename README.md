# Cookbooks for App Server

## Description

* 172.20.10.11 Dev Server (Chef)
* 172.20.10.12 Web Server
* 172.20.10.13 DB Server / Storage Server

You can "knife solo cook root@targethost" for the first time.
But this cookbooks revoke ssh login from root, you should use "knife solo cook devuser@targethost" from the second time.

## Setup

## Refs.

* http://www.slideshare.net/JulianDunn/beginner-chef-antipatterns
* http://www.creationline.com/lab/3080
* http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns/
* Chef-Soloの構成についての考察
 * http://qiita.com/mokemokechicken/items/8369ff19453f73913f1e

