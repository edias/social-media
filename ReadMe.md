# Social media

A small and very simple app that displays a list of posts and comments. All posts and comments can be searched by title or body content.

## Getting Started

Just download the project on the following URL https://github.com/edias/social-media/archive/refs/heads/main.zip and unzip the file.

### Prerequisites

The only requirement is XCode 12.5.1

### Installing

Open social-media and run the project on a device or simulator.

### Theming

Support Dark and Light mode.

## Scenarios

These are three possible scenarios.

### Success Scenario

Just run the app on any device or simulator until you can see the list of posts. Tap in any post and you should see the list of comments associated with it.

### Network Offline Scenario with Error on the lists of posts

Close the app from the device or simulator, turn off the internet connection and run the app again. You should see a network offline connection page.

From that, you can just turn on the internet connection and tap the try again button. That should take the app to the success scenario.

### Network Offline Scenario with Error on the lists of comments

On the list of posts, turn off the internet connection and tap in one of the posts. You should see a network offline connection page on the comments page.

From that, you can just turn on the internet connection and tap the try again button. That should display the comments.

## Running the tests

Just go to test navigator on XCode and run SocialMediaTests. This target contains all unit tests including NetworkServices, ViewModels, Serializer and NetworkStatusHandler test classes.
