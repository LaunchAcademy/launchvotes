# LaunchVotes
[ ![Codeship Status for davidrf/launchvotes](https://codeship.com/projects/fab74fe0-367a-0133-6163-2615b91c1f97/status?branch=master)](https://codeship.com/projects/100909) [![Code Climate](https://codeclimate.com/github/davidrf/launchvotes/badges/gpa.svg)](https://codeclimate.com/github/davidrf/launchvotes) [![Coverage Status](https://coveralls.io/repos/davidrf/launchvotes/badge.svg?branch=master&service=github)](https://coveralls.io/github/davidrf/launchvotes?branch=master)

## Description
A Rails app that allows users to nominate each other for awards and vote on them. Inspired by the [Sinatra app](https://github.com/omidbachari/launchvotes) built by [Omid Bachari](https://github.com/omidbachari) and [Alex Morgan](https://github.com/AlexMorgan).

[Click Here To View Heroku Application](https://launch-votes.herokuapp.com/)

[Click Here To View Storyboard](https://trello.com/b/TJ1R0zUz/launchvotes)

## ER Diagram
![ER Diagram](http://imgur.com/V0LNEqk.png)

## Challenges Faced
* Incorporating Github OmniAuth for user athentication.
* Building a secure admin interface.
* Employing Active Record callbacks to prevent modification and deletion of critical data.
* Using scopes to construct precise Active Record queries.
* Designing a visually attractive pages with SASS.
* Enhancing user interface with AJAX.

## Setting Up Locally
1. First clone down the repo, load the schema, and run the seed file.

  ```
  $ git clone https://github.com/davidrf/launchvotes.git
  $ rake db:setup
  ```
2. Sign In To Github and [register a new OAuth application](https://github.com/settings/applications/new).
 - For the "Homepage URL", fill in `http://localhost:3000`
 - For the "Authorization callback URL", fill in `http://localhost:3000/users/auth/github`
3. Once the application is registered, create a `.env` using the `.env.example` as a template and use the "Client ID" and "Client Secret" from your registered OAuth application.
4. Start the server.

  ```
  $ rails server
  ```
5. Visit [your application](http://localhost:3000).
