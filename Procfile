web: bundle exec rails s -p $PORT 



async_background_worker: rake environment TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 resque:work QUEUE=async_background_worker

