# Weather Forecast App
This is a small iOS app built using Swift to fetch the weather forecast of multiple cities. The app displays the weather information for multiple cities provided by the user and also displays the weather forecast for the current city using GPS for the next 5 days, with updates every 3 hours.

## Features
- User can enter a minimum of 3 cities and a maximum of 7 cities to get the weather information.
- Displays the temperature (minimum and maximum), weather description, and wind speed for each city.
- Displays the weather forecast for the current city for the next 5 days, with updates every 3 hours.
- Caches previous fetch results based on date to show the weather information in case of no internet connectivity.
## API Used
The app uses the OpenWeatherMap API to fetch the weather information for cities and the weather forecast for 5 days.

## Requirements
- Xcode 13 or later
- iOS 13 or later
- Swift 5 or later
## Installation
- Clone or download the repository.
- Open the WeatherApp.xcodeproj file in Xcode.
- Wait for Swift packages to install.
- Build and run the app on a simulator or a physical device.
## How to Run Tests
- Open the WeatherApp.xcodeproj file in Xcode.
- Go to Product -> Test or use the shortcut Cmd + U.
- The tests will run, and the results will be shown in the Xcode console.
## How to Generate Code Coverage Report
- Open the WeatherApp.xcodeproj file in Xcode.
- Go to Product -> Scheme -> Edit Scheme or use the shortcut Cmd + Shift + ,.
- Select Test from the left panel and check the box next to "Gather coverage data".
- Go to Product -> Test or use the shortcut Cmd + U.
- After the tests are completed, go to Report Navigator.
- Select Coverage tab and you will see the code coverage report.



