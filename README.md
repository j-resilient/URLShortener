## Summary
Second full project in App Academy's SQL course, first project using Rails.  
A command line URL shortener. Functionality:
- Shortens URLs and persists them to a database
- Tracks users by emails
- Tracks how many times a shortened URL is visited
## Technology Stack  
Ruby 2.5, Rails 5.2.4, Postgresql
## How to use
To create a new ShortenedUrl entry on the command line run:  
ShortenedUrl.create_for_user_and_long_url!(user_id, long_url)


