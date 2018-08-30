# Fakebook / Coolpay
This little app integrates with the [Coolpay API](http://docs.coolpayapi.apiary.io/) in order to allow sending money to users.

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/10452ee0e12c4180926030bc56c9260d)](https://app.codacy.com/app/jepettoruti/coolapi_fakebook?utm_source=github.com&utm_medium=referral&utm_content=jepettoruti/coolapi_fakebook&utm_campaign=Badge_Grade_Dashboard)
[![CircleCI](https://circleci.com/gh/jepettoruti/coolapi_fakebook.svg?style=svg)](https://circleci.com/gh/jepettoruti/coolapi_fakebook)

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

At the moment this app is not connecting to any DB (other than an empty sqlite provided by rails).

Rspec was used for tests.

An important assumption is that there is a single Coolpay API key, which is going to be used by our service to connect to Coolpay. If multiple users use our service, then authentication and validation of users need to happen on our side, not by using many Coolpay keys.

At the moment, the app is just a basic wrapper around the Coolpay API, but it's intended to be a foundation for adding more features.

There is a Coolpay API client which uses HTTParty. There are many HTTP client implementations, probably worth having a discussion with the team around which one to use for consistency. 

## Configuration
The app uses environment variables to receive configuration parameters such as secrets.
The following settings are required, and can be passed as ENV or using a dotenv file.

```
COOLPAY_USERNAME=<Your Coolpay Username>
COOLPAY_API_KEY=<Your Coolpay API Key>
COOLPAY_API_URL=https://coolpay.herokuapp.com/api
```

## Development setup
I used Ruby version 2.5.1 as it is the latest stable.
It doesn't require any particular system dependencies apart from a working Ruby environment with Bundler.

1. Add environment variables (or `.env` file) as described in the [Configuration](https://github.com/jepettoruti/coolapi_fakebook#configuration) section.
2. Just clone and `bundle install`.
3. Start your server.

For improvements, please create a PR on the repository and hopefully it can be merged soon.

## Running Tests
CircleCI is configured to run tests on CI. 
Also Codacy is used to provide static code analysis.

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

**Note:** There is no call or API exposed for authentication at the moment from the app. The authentication with Coolpay happens automatically on each call. As discussed in [Next Steps](https://github.com/jepettoruti/coolapi_fakebook#next-steps), an user authentication system needs to be implemented.

## Deployment
Of course this service needs a security audit, configure logs and proper monitoring before deployment.
That being said, I added a basic Procfile and Dockerfile which can be used as a good starting point for deploying this app.

You can run it by doing something like this:

```
docker build -t coolpay_api .
docker run --env PORT=3000 --env COOLPAY_USERNAME=<USERNAME> --env COOLPAY_API_KEY=<KEY> --env COOLPAY_API_URL=https://coolpay.herokuapp.com/api --env RAILS_LOG_TO_STDOUT=true -p 3000:3000 coolpay
```

## Next steps
I believe this service provides the very basic MVP required by the scenario.
Not ready for production, but here are some ideas that may be considered in the future:

- Add authentication on the app side, so multiple users can create payments by being authorised to do so. This can be done by using something like Auth0 or Devise.
- Add VCR into specs so no APIs calls need to be made every time it builds
- Improve input validation on both the service and the API client
- Improve management of edge cases and errors on the client (and service)
- Add a DB in order to store transactions and provide methods to access those
- Process payments in background (if Coolpay is slow, or dead temporarily, also the ability to retry)
- Improve the ways to manage accepted currencies
- Add some sort of fraud protection and anti money-laundering capabilities
- Add better logging and instrumentation on different parts of the code to have better observability in production
- Improve (create) puma configuration to better adapt to infrastructure setup
- Provide an OpenAPI (Swagger) specification for the service so other users/systems can have a clear view on how to interact with this service
- Add integration to an Exception Management service like Sentry.
- Send custom performance metrics to monitoring.
- Refactor client file and split to some files.
- Add caching for exposed APIs.
- Ask Coolpay to implement a proper search of payments. Using a call that provides _ALL_ payments is definitely slow and not very scalable.