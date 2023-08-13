# Use the official Ruby image as the base image
FROM ruby:2.7

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile /app/

# Install dependencies using Bundler
RUN bundle install

# Copy the Sinatra app files to the container
COPY . /app/

# Expose the port the Sinatra app will run on
EXPOSE 4567

# Command to start the Sinatra app using rackup
CMD ["rackup", "rackup.ru", "--host", "0.0.0.0", "--port", "4567"]
