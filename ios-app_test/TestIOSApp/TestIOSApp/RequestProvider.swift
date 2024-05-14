import Foundation
import Alamofire
import Combine


class RequestProvider {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let kServerUrl = "https://gist.githubusercontent.com/Disconnecter/ba9872ace953e382b3497ba358940ca9/raw/90f9f3344b0539a71e7abcb69578c6dadb817a86/gistfile1.txt"
    
    var request: URLRequest {
        URLRequest(url: URL(string: kServerUrl)!)
    }
    
    //binding publishers
    func bind(_ input:  AnyPublisher<CarsInput, Never>) -> AnyPublisher<CarListState, Never> {
        
        let output = PassthroughSubject<CarListState, Never>()
        
        input.sink {  [weak self] input in
            switch input {
             case .initial:
                self?.requestData(completionHandler: { data,error  in
                    if let data = data {
                        output.send( .success(data))
                    } else if let error = error {
                        output.send( .failure(error))
                    }
                })
            }
                
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    
    func requestData(completionHandler: @escaping (DescriptionModel?, Error?) -> Void) {
        
        AF.request(kServerUrl, interceptor: .retryPolicy).response { response in
            
            if let data = response.data {
                do {
                    let cars = try JSONDecoder().decode(DescriptionModel.self, from: data)
                    completionHandler(cars, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
