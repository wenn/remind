# Remind

## Install
`gem install remind`

## Usage
+ Add an entry
```
  $ remind me on monday
  > the title
  > the body
  > more of the body
```
+ `remind list`

## Development
`bundle install`

## Run Tests
`rake test`

## Package gem
`rake package`

## TODO
- add readme Usage
- add "every <day|week|month|year>"
- add "in <count> <days>"
- add "next <time>"
- Set up smtp server to replase TextBelt so we can send from, subject and body texts
