//
//  AppMainViewTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
import SwiftUI
@testable import RickyBuggy

class AppMainViewTests: XCTestCase {
    var viewModel: AppMainViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AppMainViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialLoadingState() {
        let view = AppMainView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        _ = controller.view
        
        XCTAssertNotNil(controller.view, "The view should be initialized and not nil.")
    }
    
    func testSortActionSheetPresentation() {
        let view = AppMainView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        _ = controller.view
        
        XCTAssertFalse(viewModel.showsSortActionSheet, "The action sheet should not be shown initially.")
        
        viewModel.setShowsSortActionSheet()
        XCTAssertTrue(viewModel.showsSortActionSheet, "The action sheet should be shown when the sort button is tapped.")
    }
    
    func testSortActionSheetButtonActions() {
        let view = AppMainView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        _ = controller.view
        
        viewModel.setSortMethod(.episodesCount)
        XCTAssertEqual(viewModel.sortMethod, .episodesCount, "The sort method should be set to episodes count when the corresponding button is tapped.")
        
        viewModel.setSortMethod(.name)
        XCTAssertEqual(viewModel.sortMethod, .name, "The sort method should be set to name when the corresponding button is tapped.")
    }
}
