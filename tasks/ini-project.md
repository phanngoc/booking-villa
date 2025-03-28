# How to Initialize a Ruby on Rails Project

Here's how to create a new Ruby on Rails project:

## Prerequisites
1. Install Ruby (if not already installed)
   ```bash
   # On macOS with Homebrew
   brew install ruby
   
   # On Ubuntu/Debian
   sudo apt-get install ruby-full
   ```

2. Install Rails gem
   ```bash
   gem install rails
   ```

## Creating a New Rails Project
1. Create a new Rails application
   ```bash
   rails new myapp
   ```
   This creates a new Rails application called "myapp" with default configurations.

2. With specific database (e.g., PostgreSQL)
   ```bash
   rails new myapp --database=postgresql
   ```

3. Change into the application directory
   ```bash
   cd myapp
   ```

4. Start the Rails server
   ```bash
   rails server
   # or shorter version
   rails s
   ```

5. Visit http://localhost:3000 in your browser to see your new Rails application running.

## Additional Setup
- Create the database: `rails db:create`
- Generate a controller: `rails generate controller Pages home`
- Generate a model: `rails generate model User name:string email:string`
- Run migrations: `rails db:migrate`

Would you like me to provide more specific details about any part of the setup process?