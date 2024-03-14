# FROM ruby:3.2.0

# RUN apt-get update -qq && \
#     apt-get install -y build-essential libvips && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# WORKDIR /rails

# ENV RAILS_LOG_TO_STDOUT="1" \
#     RAILS_SERVE_STATIC_FILES="true" \
#     RAILS_ENV="production" \
#     BUNDLE_WITHOUT="development"

# COPY Gemfile Gemfile.lock ./
# RUN bundle install

# COPY . .

# RUN bundle exec bootsnap precompile --gemfile app/ lib/

# RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# ENTRYPOINT [ "/rails/bin/docker-entrypoint" ]

# EXPOSE 3000
# CMD [ "./bin/rails", "server" ]

# Use the official Ruby image from Docker Hub
FROM ruby:3.2.0

# Set environment variables for the Rails app
ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

# Set up the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs yarn postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs $(nproc) --retry 5

# Copy the rest of the application code into the container
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
