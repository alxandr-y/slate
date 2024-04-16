FROM ruby:2.6-slim

WORKDIR /srv/slate

# Expose port for the server
EXPOSE 4567

# Copy Gemfile and Gemfile.lock
COPY Gemfile .
COPY Gemfile.lock .

# Update system and install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        nodejs \
    # Update RubyGems to the latest version that avoids the bug
    && gem update --system 3.2.3 \
    # Install Bundler and gems based on the updated RubyGems
    && gem install bundler \
    && bundle install \
    # Clean up unnecessary packages and clear apt cache to reduce image size
    && apt-get remove -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Copy the rest of the application
COPY . /srv/slate

# Ensure the entry script is executable
RUN chmod +x /srv/slate/slate.sh

# Set the container's main command
ENTRYPOINT ["/srv/slate/slate.sh"]
CMD ["build"]
