import Foundation

enum StoreError: Error {
    case decodeFailure
    case unknown
}

class Store {
    static let shared = Store()

    private let baseURL = "https://3.vbb.transport.rest"

    func loadDepartures(station: Station, completion: @escaping (Result<[Departure], StoreError>) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/stops/\(station.id)/departures")!
        urlComponents.queryItems = [URLQueryItem(name: "duration", value: "15")]
        let url = urlComponents.url!

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                do {
                    let decodedResponse = try decoder.decode([Departure].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse))
                    }
                } catch _ {
                    completion(.failure(.decodeFailure))
                }
                return
            }
            completion(.failure(.unknown))
        }.resume()
    }
}
