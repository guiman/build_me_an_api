# BuildMeAnApi
[![Build Status](https://travis-ci.org/guiman/build_me_an_api.png)](https://travis-ci.org/guiman/build_me_an_api)
[![Code Climate](https://codeclimate.com/github/guiman/build_me_an_api.png)](https://codeclimate.com/github/guiman/build_me_an_api)

A tool that allows you to build an API very easy, giving you a working API template that you can later modify to your needs.

## Motivation

Sometimes when I have an idea and need to build something fast with minor detials it really bugs me to write the same boilerplate code over and over again, just to get an API working. So It would be very cool if I could just say some minor detials about what I need a it just worked.

Well this is looking to be a solution:

* It's fast enough so I don't need to write much
* It's very easy to replicate
* If I like where it is going I can use it as a start and don't throw it away.

## Installation

Add this line to your application's Gemfile:

    gem 'build_me_an_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install build_me_an_api

## Usage
Once you have installed it, you will have the ```build_me_an_api``` command that works this way:

```bash
build_me_an_api my_new_api sqlite:memory: resource_descriptor.json
```

Parameters are:
1. api_name
2. Database dsn string
3. File containing the resources desciption

Resource descriptor files are just JSON files that look like this:

```json
{
  "resources":
  [{
    "name": "basic_model",
    "attributes":
    {
      "id": "integer",
      "name": "string",
      "pk": "id"
    }
  },
  {
    "name": "other_model",
    "attributes":
    {
      "id": "integer",
      "name": "string",
      "pk": "id"
    }
  }]
}
```

Inside "attributes", the key represents the name of the attribute and the value is the Type.

Since I'm using DataMapper, check their site for [possible values](http://datamapper.org/docs/dm_more/types.html)

It will create a folder named ```my_new_api``` like this:

```
my_new_api/
  Gemfile
  api.rb
  config/
    database.yml
  config.ru
  model/
    basic_model.rb
    other_model.rb
```

All you need to do now is just cd into that directory and execute ```bundle; bundle exec rackup```, and voila! Your have an api ready to be used.

Out of the box the API allows you to:

* List all
* Show
* Insert
* Update

URLs are built based on each resource "name" attribute, so:

* GET /other_model -> List all other_model instances
* GET /other_model/:id -> Show a certain other_model instance
* POST /other_model -> Create a other_model instance. Params are expected to be sent in an array called "other_model"
* POST /other_model -> Update certain other_model instance. Params are expected to be sent in an array called "other_model"

### Wait, not happy with the template?

Well if you are not very happy with what it cames bundled with, you can always modify it :D.

## Coming soon!

* Related resources
* Being able to create your own api templates
* Tons of tests...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

##Author
Alvaro Fernando Lara - alvarola at gmail.com