//
//  StepTwoViewModelTests.swift
//  WeatherAppTests
//
//  Created by MOHAMED REBIN K on 05/03/23.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class StepTwoViewModelTests: XCTestCase {
    
    var viewModel: StepTwoViewModel!
    var locationManager: CLLocationManager!
    
    override func setUp() {
        super.setUp()
        viewModel = StepTwoViewModel()
        locationManager = viewModel.locationManager
    }
    
    override func tearDown() {
        viewModel = nil
        locationManager = nil
        super.tearDown()
    }
    
    func testGetCurrentLocation() {
           // Set up expectation
           let expectation = XCTestExpectation(description: "Location update")

           // Define the expected location
           let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)

           // Start location updates
           viewModel.getCurrentLocation()

           // Call the mock's delegate method with the expected location
        locationManager.delegate?.locationManager?(locationManager, didUpdateLocations: [expectedLocation])

           // Wait for the expectation to be fulfilled
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               // Check that the view model's currentLocation is updated to the expected location
               XCTAssertEqual(self.viewModel.currentLocation?.coordinate.latitude, expectedLocation.coordinate.latitude)
               XCTAssertEqual(self.viewModel.currentLocation?.coordinate.longitude, expectedLocation.coordinate.longitude)

               // Fulfill the expectation
               expectation.fulfill()
           }

           // Wait for the expectation to be fulfilled or timed out
           wait(for: [expectation], timeout: 5.0)
       }
}
