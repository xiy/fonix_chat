# Fonix Chat

## Plan

I use [jujutsu](https://jj-vcs.github.io/jj/latest/) as it makes it easier for my ADHD to keep track of the changes I've made. It's compatible with git and github, but you'll see more detail with `jj log`.

### GO!
- [x] Setup Rails 8 app with Devise
- [x] Setup basic user authentication

### Checkpoint 1

- [x] Add a channel model to store channels, make it easily extendable for future channel types
- [x] Add a channel user model to store user memberships to channels
- [x] Add a message model to store user messages per channel
- [x] Add a very basic frontend for joining channels and sending messages using Stimulus/Hotwire/Turbo
- [x] Setup a channel subscription through ActionCable/SolidCable and connect with Stimulus/Hotwire/Turbo
- [x] Test multiple users sending messages to the same channel and receiving them in real time


### Checkpoint 2
- [x] Add a weekly email summary
- [x] Add a scheduled job to send the weekly email summary using ActiveJob and SolidQueue


YAY!
## Setup

```bash
bundle install
bin/setup
```

## Run the server

```bash
rails s
```

## Run the tests

```bash
rails test:all
```

## Uses
- [Rails 8](https://rubyonrails.org/)
- [Ruby 3.2](https://www.ruby-lang.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Devise](https://github.com/heartcombo/devise)
- [Stimulus](https://stimulus.hotwired.dev/)
- [Turbo](https://turbo.hotwired.dev/)
- [Hotwire](https://hotwired.dev/)
- SolidQueue (through postgres)
- SolidCable (through postgres)

## Mailers

You can preview the weekly mailer at `http://localhost:3000/rails/mailers/weekly_email_mailer/weekly_summary`

## Scheduled Jobs

A scheduled job has been set up using `config/recurring.yml`

## Notes

### Frontend

The frontend is built with Hotwire and Stimulus but I've avoided making it look pretty due to time constraints. If I was to continue working on this, I would most likely use Tailwind CSS and make nice stimulus components.

### Pagination

Currently the app will load all messages for a channel into the view. This is obviously not scalable and I would need to implement pagination using something like [Kaminari](https://github.com/kaminari/kaminari) or [WillPaginate](https://github.com/mislav/will_paginate).

I started work on adding this and a few other nice to haves like new message notifications and scrollback but ran out of time.

### Single channel

I've tried to build the app in a way that it could be extended to support multiple channel types, e.g. direct messages, groups, etc. We would just need to extend the Channel model and add a type column for example.

Although you can currently create multiple channels in frontend, I've tested it from the perspective of a single channel.
