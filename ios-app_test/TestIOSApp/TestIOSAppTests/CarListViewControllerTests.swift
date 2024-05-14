import XCTest
@testable import TestIOSApp

class CarListViewControllerTests: XCTestCase {

    var carListViewController: CarListViewController!

    override func setUp() {
        super.setUp()
        
        carListViewController = CarListViewController()
                _ = carListViewController.view
    }

    func testWeAreShowingCarsInTableView() {
    }    
    
    
    func testShowingCarsInTableView() throws {
            // Prepare data
            let car1 = CarModel(title: "Car 1", description: "Description 1")
            let car2 = CarModel(title: "Car 2", description: "Description 2")
            let cars = DescriptionModel(title: "Cars", results: [car1, car2])

        //Gets data
        carListViewController.refreshData(.success(cars))
        
            XCTAssertEqual(carListViewController.tableView.numberOfRows(inSection: 0), cars.results.count)

            for (index, car) in cars.results.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                let cell = carListViewController.tableView(carListViewController.tableView, cellForRowAt: indexPath)
                
                
                var content = cell.defaultContentConfiguration()
                content.text = car.title
                content.secondaryText = car.description
                
                XCTAssertEqual(content.text, car.title)
                XCTAssertEqual(content.secondaryText, car.description)
                cell.contentConfiguration = content
            }
        }

}
