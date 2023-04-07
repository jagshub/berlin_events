# README

* Install redis

    `* brew install redis
        /opt/homebrew/opt/redis/bin/redis-server /opt/homebrew/etc/redis.conf
        brew services restart redis`

* Database creation
```
    rails db:create
    rails db:seed
    rails db:migrate
```

* Start sidekiq
```
sidekiq
```

* Populate Events using console
```azure

scraper = ScrapingService.new
scraper.perform

```