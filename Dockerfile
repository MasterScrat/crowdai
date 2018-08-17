FROM ruby:2.5.1

ENV APP_HOME /app

RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-common \
    postgresql-9.6 \
    postgresql-client \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN gem install bundler && gem install foreman && bundle install --jobs 4 --retry 3

COPY . $APP_HOME

ENV REDIS_URL redis://redis:6379

#RUN mkdir tmp && curl -o tmp/crowdai-prd.dmp "https://xfrtu.s3.amazonaws.com/84fcd9fe-4f5b-42c5-b795-59f4875b47f8/2018-08-02T20%3A42%3A05Z/4462d6a9-7f75-4da5-9644-fa124accd048?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJ5HNUZMBKBNNOSYQ%2F20180802%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20180802T204512Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=d6966828ecec169067fcb74d5078a100c34515b85d4a6fea6b37a753ccb22f10"

#RUN rake db:create

#RUN dropdb crowdai_development && createdb crowdai_development && pg_restore --no-acl --no-owner -d crowdai_development tmp/crowdai-prd.dmp

CMD bundle exec rails s -p ${PORT} -b '0.0.0.0'

#CMD foreman start -f Procfile.dev