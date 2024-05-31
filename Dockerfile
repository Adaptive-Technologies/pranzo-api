# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim as base

LABEL fly_launch_runtime="rails"

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1" \
    RAILS_LOG_TO_STDOUT="true" \
    RAILS_SERVE_STATIC_FILES="true"

ARG BUNDLER_VERSION=2.4.21

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler -v ${BUNDLER_VERSION}

# Rails app lives here
WORKDIR /rails

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and application assets
ARG BUILD_PACKAGES="build-essential libpq-dev libvips git node-gyp pkg-config python-is-python3 imagemagick wget vim curl gzip xz-utils libsqlite3-dev libffi-dev libcairo2-dev libvips-dev libglib2.0-dev libgtk2.0-dev gobject-introspection"
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install necessary libraries for gobject-introspection
RUN apt-get update -qq && \
    apt-get install -y libgirepository1.0-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


# Install application gems
COPY --link Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

# Copy application code
COPY --link . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# Install deployment packages
ARG DEPLOY_PACKAGES="imagemagick libvips postgresql-client libsqlite3-0 libffi-dev libcairo2-dev libvips-dev libglib2.0-dev libgtk2.0-dev gobject-introspection"
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y $DEPLOY_PACKAGES && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js and Yarn, global npm packages
# Install Node.js and Yarn, global npm packages
RUN apt-get update -qq && \
    apt-get install -y curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs && \
    npm install -g yarn mjml mjml-qr-code


# Run and own the application files as a non-root user for security
RUN useradd rails --home /rails --shell /bin/bash
USER rails:rails

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build --chown=rails:rails /rails /rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
