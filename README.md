# Coolpay_integrations
This little app integrates with the [Coolpay API](http://docs.coolpayapi.apiary.io/) in order to allow sending money to users.

## Scenario
Coolpay is a new company that allows to easily send money to friends through their API.

You work for Fakebook, a successful social network. You’ve been tasked to integrate Coolpay inside Fakebook. A/B tests show that users prefer to receive money than pokes!

You can find Coolpay documentation here: http://docs.coolpayapi.apiary.io/

You will write a small app that uses Coolplay API in a language of your choice. The app should be able do the following:

- Authenticate to Coolpay API
- Add recipients
- Send them money
- Check whether a payment was successful

## Architecture
This app was implemented using Rails API-Only. The rational behind this is that it presents a good start for a service that potentially will grow in the future, requiring additional stuff such as storage in databases, caching, or background processing.

It could be argued that the initial scenario didn't require this and could have been implemented with something simpler such as Sinatra, but in my experience using the Rails API-Only mode is more powerful and easier to incrementally improve than starting with very basic barebones.

At the moment this app is not connecting to any DB. 

I use Rspec for tests.

## Configuration
The app uses environment variables to receive configuration parameters such as secrets.
The following settings are required, and can be passed as ENV or using a dotenv file.

```
COOLPAY_USERNAME=<Your Coolpay Username>
COOLPAY_API_KEY=<Your Coolpay API Key>
```

## Development setup
I used Ruby version 2.5.1 as it is the latest stable.
It doesn't require any particular system dependencies apart from a working Ruby environment with Bundler.

1. Add environment variables as described in the Configuration section.
2. Just clone and `bundle install`.

## Running Tests
```
bundle exec rspec
```

## Usage
TODO

## Deployment
TODO
