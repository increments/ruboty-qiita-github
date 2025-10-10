# Ruboty::Github
[![Gem Version](https://badge.fury.io/rb/ruboty-qiita-github.svg)](https://badge.fury.io/rb/ruboty-qiita-github)
[![Test](https://github.com/increments/ruboty-qiita-github/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/increments/ruboty-qiita-github/actions/workflows/test.yml)
[![Maintainability](https://qlty.sh/gh/increments/projects/ruboty-qiita-github/maintainability.svg)](https://qlty.sh/gh/increments/projects/ruboty-qiita-github)
[![Code Coverage](https://qlty.sh/gh/increments/projects/ruboty-qiita-github/coverage.svg)](https://qlty.sh/gh/increments/projects/ruboty-qiita-github)

Manage GitHub via Ruboty.
This gem adds `deploy pull request` command to original ruboty-github plugin.

## Install
```ruby
# Gemfile
gem "ruboty-github"
```

## Usage
```
@ruboty close <URL>                                       - Close an Issue
@ruboty create issue "<title>" on <repo>[\n<description>] - Create a new Issue
@ruboty merge <URL>                                       - Merge a Pull Request
@ruboty pull request "<title>" from <from> to <to>        - Create a new Pull Request
@ruboty deploy pull request "<title>" from <from> to <to> - Create a new Pull Request for Deploy
@ruboty remember my github token <token>                  - Remember sender's GitHub access token
@ruboty search issues "<query>"                           - Search an Issues/Pull Requests
```

## ENV
```
GITHUB_BASE_URL - Pass GitHub base URL if needed (e.g. https://github.example.com)
```

## Image
![](https://raw.githubusercontent.com/r7kamura/ruboty-github/master/images/screenshot.png)
