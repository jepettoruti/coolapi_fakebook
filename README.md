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

An important assumption is that there is a single Coolpay API key, which is going to be used by our service to connect to Coolpay. If multiple users use our service, then authentication and validation of users need to happen on our side, not by using many Coolpay keys.

At the moment, the app is just a basic wrapper around the Coolpay API, but it's intended to be a foundation for adding more features.

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
CircleCI is configured to run tests on CI. 

You can also run your tests locally:
```
bundle exec rspec
```

## Usage
1. Download dependencies with `bundle`
2. Start the rails server with `bundle exec rails s`
3. In another terminal, you can run the calls using cURL:

### Create Recipient
```
curl -X POST \
  http://localhost:3000/recipients \
  -F name=Johnny

{"status":"SUCCESS","recipient_id":"5684306e-9972-4864-9803-63d0e5f558ce"}
```

### Create Payment
```
curl -X POST \
  http://localhost:3000/payments \
  -F amount=30 \
  -F currency=GBP \
  -F recipient_id=e4dbd5cc-bcc7-4b6d-9312-30513e9b5b27

{"status":"SUCCESS","payment_id":"263d190c-24d9-45f0-b87f-e548d929b960"}
```

### Check Status of Payment
```
curl -X GET 'http://localhost:3000/payments/status/?payment_id=afad910b-697f-4d05-bf7a-ad6d2f4ef4e4' 

{"payment_status":"paid"}
```

## Deployment
TODO
