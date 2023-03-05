//
//  StepOneViewModelTests.swift
//  WeatherAppTests
//
//  Created by MOHAMED REBIN K on 05/03/23.
//

import XCTest
@testable import WeatherApp

final class StepOneViewModelTests: XCTestCase {
    
    var viewModel: StepOneViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = StepOneViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testValidateUserEnteredCities() {
        // Test with valid number of cities
        XCTAssertTrue(viewModel.validateUserEnteredCities(3))
        XCTAssertTrue(viewModel.validateUserEnteredCities(5))
        XCTAssertTrue(viewModel.validateUserEnteredCities(7))
        
        // Test with invalid number of cities
        XCTAssertFalse(viewModel.validateUserEnteredCities(0))
        XCTAssertFalse(viewModel.validateUserEnteredCities(1))
        XCTAssertFalse(viewModel.validateUserEnteredCities(2))
        XCTAssertFalse(viewModel.validateUserEnteredCities(8))
        XCTAssertFalse(viewModel.validateUserEnteredCities(10))
    }

}

