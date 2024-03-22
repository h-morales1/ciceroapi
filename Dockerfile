ARG RUBY_VERSION=3.1.0

FROM registry.docker.com/library/ruby:$RUBY_VERSION-alpine as base

WORKDIR /rails 

# prod environment
ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Throw-away build stage to reduce size of final image
FROM base as build

RUN apk add --update --no-cache \
    build-base \
    curl \
    git \
    less \
    vips-dev\
    postgresql-client\
    yarn\
    postgresql-dev\
    libpq\
    libpq-dev\
    tzdata\
    gcompat\
    libstdc++


#Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/


# Final stage for app image
FROM base

RUN apk add --update --no-cache \
    build-base \
    curl \
    git \
    less \
    vips-dev\
    postgresql-client\
    yarn\
    postgresql-dev\
    libpq\
    libpq-dev\
    tzdata\
    gcompat\
    libstdc++

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
#RUN adduser rails && \
#    chown -R rails:rails db log storage tmp
#USER rails:rails
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
