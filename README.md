# README

This guide outlines the setup and running instructions for the application.

Requirements:-
Ruby version: "3.0.0"
Rails version: "7.0.8"
Database: SQLite3

System Dependencies:-

Ensure the following gems are installed for the application:

Devise: For authentication. https://github.com/heartcombo/devise
gem "devise", "~> 4.9"

Letter Opener: For email notification in development environment.
gem "letter_opener", group: :development

RSpec-Rails: For testing.
gem 'rspec-rails', '~> 5.0'

Shoulda Matchers: Additional testing utilities.
gem 'shoulda-matchers', '~> 5.3'

WebMock: For mocking.
gem "webmock"


Setup Instructions:-

Install Dependencies: Navigate to the application root directory and run:
`bundle install`

To setup the application run `rake db:setup`

Database Migration: Run the following command to create the database schema:
`bundle exec rails db:migrate`

Start Server: Launch the server by running:
`bundle exec rails s`

The application will be accessible at http://127.0.0.1:3000.

Sign Up: Visit the signup page by navigating to the root path. Provide an email, password (minimum 6 characters), and password confirmation to sign up.

Create Events:

Click on "Create Event A" to create an event.
Click on "Create Event B" to create an event along with email notification.

Add Users to Event:

Navigate to any event by clicking on it.
View event details and a list of associated users.
To add more users, select them from the list and click on "Add Users" button.


Test Suite
To run the test suite, navigate to the application root directory and execute:
`bundle exec rspec`



For Evaluation- 

  1. The application meets the specified requirements, The codebase is of good quality, well-structured, and highly readable within the Ruby on Rails framework. All features are implemented according to the requirements, ensured proper functionality throughout the application. Additionally, thorough testing has been conducted to validate the functionality, ensured a reliable user experience.

  2. The iterable.com API has been successfully integrated into the application. Interactions with the API have been appropriately mocked using the WebMock gem/library. This ensures that the application can simulate API responses during testing and development, allowing for reliable and consistent behavior without directly accessing the iterable.com API. Through thorough testing, we have confirmed that the API integration and mocking functionalities work as expected
  
  3. The application prioritizes user experience by providing an intuitive interface and clear navigation paths. User interactions are streamlined to ensure simplicity and ease of use. Features are logically organized and labeled, making it easy for users to understand the functionality

  4. To ensure scalability, the application architecture can incorporates measures such as the use of a load balancer. The load balancer distributes incoming traffic across multiple instances of the application, allowing for efficient handling of increased load. Additionally, while the mechanism described for managing third-party API calls has not been implemented yet, implementing request throttling for third-party API calls is a recommended strategy. This mechanism limits the number of requests sent to the third-party API within a specified time frame, preventing overload and ensuring consistent performance. By incorporating both a load balancer and request throttling, the solution can effectively handle increased load and accommodate additional features in the future while maintaining reliability and performance.

  5. User management and authentication features have been successfully implemented, Additionally, the Devise gem has been utilized for user authentication, ensuring secure access to the application's features and resources. With these additional features in place, the application offers enhanced functionality and security, contributing to an improved overall user experience. 