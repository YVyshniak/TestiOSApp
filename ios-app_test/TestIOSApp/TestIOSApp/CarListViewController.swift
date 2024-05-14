import Combine
import UIKit

final class CarListViewController : UITableViewController {
    static let cellReuseIdentifier = "UITableViewCellCellReuseIdentifier"
    
    var cancellables: [AnyCancellable] = []
    let input = PassthroughSubject<CarsInput, Never>()
    let provider = RequestProvider()
    var state = CarListState.loading
    var cars:DescriptionModel? {
        didSet {
            tableView.reloadData()
            self.title = cars?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
        
        //binding
        let output = provider.bind(input.eraseToAnyPublisher())

        output.sink(receiveValue: {[weak self] state in
            self?.refreshData(state)
        }).store(in: &cancellables)
        
        input.send(.initial)
    }
    
    public func refreshData(_ stateUpdate: CarListState) {
        self.state = stateUpdate
        
        switch state {
            case .loading: input.send(.initial)
            case .success(let model): self.cars = model
            case .failure(let error): self.title = "Error"
            print(error.localizedDescription)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        if let cars = cars {
            
            var content = cell.defaultContentConfiguration()
            content.text = cars.results[indexPath.row].title
            content.textProperties.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            content.secondaryText = cars.results[indexPath.row].description
            content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
            cell.contentConfiguration = content
        }
        return cell
    }
}
