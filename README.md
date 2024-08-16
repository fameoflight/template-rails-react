# Rails React Template

This is very opinionated template for Rails and React application, powered by Relay(modern).

Please don't different namings, this is amalgamation of my various projects.

### Powered by:

- Rails 7
- Rspec and factory_bot for testing
- React 18 and Relay Modern (Typescript and Suspense)
- Tailwind CSS

### Features:

- User authentication
- User authentication with Google Identity Service
- Model versioning with PaperTrail
- Graphql API (Relay compatible). Directly build node from postgres table
- Bugsnag integration
- LogDNA integration (with lograge)
- Background job with good_job (run on your postgres)
- File upload with ActiveStorage
- Spoof user for testing (to test as different user).
- Code coverage with simplecov
- Encrypted GraphQL ID's

# Backend

1. Copy master.key to niaum-api/config
2. Install dependencies using `bundle install`
3. Setup database using `rails db:setup && RAILS_ENV=test rails db:setup`
4. Run test using `rspec` or `COV=1 rspec` for coverage
5. Start server using `rails s`

# Frontend

1. Install dependencies using `yarn install`
2. Start dev process using `yarn dev`
3. Start server using `yarn web`

# Deployment

1. Backend

```bash
web: bundle exec puma -C config/puma.rb
worker: bundle exec good_job start  --poll-interval=5 --max-cache=50 --enable-cron
```

2. Frontend

```bash

yarn build
yarn serve
```
