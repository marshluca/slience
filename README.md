Slience
===============

A website build with [Sinatra](http://www.sinatrarb.com/), including an API service based on [Grape](https://github.com/intridea/grape).


### Installation
```
bundle install --path=vendor/bundle

bundle exec rackup config.ru
```
visit http://localhost:9292

### Testing

```
bundle exec rake spec
```

### Deployment

http://recipes.sinatrarb.com/#deployment_nginx_proxied_to_unicorn
http://recipes.sinatrarb.com/#deployment_apache_with_passenger