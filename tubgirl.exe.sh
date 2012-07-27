#!/bin/sh
bundle install --without assets test development
bundle exec rake production:go
