```
bw = Brewery.create name: "BrewDog", year: 2007
b1 = bw.beers.create name: "Punk IPA", style: "IPA"
b2 = bw.beers.create name: "Nanny State", style: "lowalcohol"
b1.ratings.create score:48
b1.ratings.create score:56
b1.ratings.create score:54
b2.ratings.create score:23
b2.ratings.create score:35
b2.ratings.create score:18

---

irb(main):002:0> bw = Brewery.create name: "BrewDog", year: 2007
   (0.2ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "breweries" ("name", "year", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "BrewDog"], ["year", 2007], ["created_at", "2015-01-24 11:20:05.723756"], ["updated_at", "2015-01-24 11:20:05.723756"]]
   (1.4ms)  commit transaction
=> #<Brewery id: 4, name: "BrewDog", year: 2007, created_at: "2015-01-24 11:20:05", updated_at: "2015-01-24 11:20:05">
irb(main):003:0> b1 = bw.beers.create name: "Punk IPA", style: "IPA"
   (0.0ms)  begin transaction
  SQL (0.3ms)  INSERT INTO "beers" ("name", "style", "brewery_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["name", "Punk IPA"], ["style", "IPA"], ["brewery_id", 4], ["created_at", "2015-01-24 11:21:48.391267"], ["updated_at", "2015-01-24 11:21:48.391267"]]
   (1.4ms)  commit transaction
=> #<Beer id: 9, name: "Punk IPA", style: "IPA", brewery_id: 4, created_at: "2015-01-24 11:21:48", updated_at: "2015-01-24 11:21:48">
irb(main):004:0> b2 = bw.beers.create name: "Nanny State", style: "lowalcohol"
   (0.1ms)  begin transaction
  SQL (0.2ms)  INSERT INTO "beers" ("name", "style", "brewery_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["name", "Nanny State"], ["style", "lowalcohol"], ["brewery_id", 4], ["created_at", "2015-01-24 11:22:08.818745"], ["updated_at", "2015-01-24 11:22:08.818745"]]
   (1.6ms)  commit transaction
=> #<Beer id: 10, name: "Nanny State", style: "lowalcohol", brewery_id: 4, created_at: "2015-01-24 11:22:08", updated_at: "2015-01-24 11:22:08">
irb(main):005:0> b1.ratings.create score:48
   (0.0ms)  begin transaction
  SQL (0.2ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["score", 48], ["beer_id", 9], ["created_at", "2015-01-24 11:22:28.145432"], ["updated_at", "2015-01-24 11:22:28.145432"]]
   (1.4ms)  commit transaction
=> #<Rating id: 4, score: 48, beer_id: 9, created_at: "2015-01-24 11:22:28", updated_at: "2015-01-24 11:22:28">
irb(main):006:0> b1.ratings.create score:56
   (0.1ms)  begin transaction
  SQL (0.2ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["score", 56], ["beer_id", 9], ["created_at", "2015-01-24 11:22:32.594760"], ["updated_at", "2015-01-24 11:22:32.594760"]]
   (1.4ms)  commit transaction
=> #<Rating id: 5, score: 56, beer_id: 9, created_at: "2015-01-24 11:22:32", updated_at: "2015-01-24 11:22:32">
irb(main):007:0> b1.ratings.create score:54
   (0.2ms)  begin transaction
  SQL (0.3ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["score", 54], ["beer_id", 9], ["created_at", "2015-01-24 11:22:37.938810"], ["updated_at", "2015-01-24 11:22:37.938810"]]
   (1.5ms)  commit transaction
=> #<Rating id: 6, score: 54, beer_id: 9, created_at: "2015-01-24 11:22:37", updated_at: "2015-01-24 11:22:37">
irb(main):008:0> b2.ratings.create score:23
   (0.1ms)  begin transaction
  SQL (0.3ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["score", 23], ["beer_id", 10], ["created_at", "2015-01-24 11:22:48.667655"], ["updated_at", "2015-01-24 11:22:48.667655"]]
   (1.5ms)  commit transaction
=> #<Rating id: 7, score: 23, beer_id: 10, created_at: "2015-01-24 11:22:48", updated_at: "2015-01-24 11:22:48">
irb(main):009:0> b2.ratings.create score:35
   (0.1ms)  begin transaction
  SQL (0.8ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["score", 35], ["beer_id", 10], ["created_at", "2015-01-24 11:22:51.819087"], ["updated_at", "2015-01-24 11:22:51.819087"]]
   (1.4ms)  commit transaction
=> #<Rating id: 8, score: 35, beer_id: 10, created_at: "2015-01-24 11:22:51", updated_at: "2015-01-24 11:22:51">
irb(main):010:0> b2.ratings.create score:18
   (0.1ms)  begin transaction
  SQL (0.2ms)  INSERT INTO "ratings" ("score", "beer_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["score", 18], ["beer_id", 10], ["created_at", "2015-01-24 11:22:54.579217"], ["updated_at", "2015-01-24 11:22:54.579217"]]
   (1.4ms)  commit transaction
=> #<Rating id: 9, score: 18, beer_id: 10, created_at: "2015-01-24 11:22:54", updated_at: "2015-01-24 11:22:54">
```