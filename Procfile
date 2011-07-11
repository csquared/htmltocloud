web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: RACK_ENV=$RACK_ENV bundle exec rake QUEUE=* resque:work
