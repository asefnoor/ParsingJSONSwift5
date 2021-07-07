import Foundation

struct JSONManager {
    
    func readFromFile(name: String) -> String {
        guard
            let fileURL = Bundle.main.url(forResource: name, withExtension: "json"),
            let fileContents = try? String(contentsOf: fileURL)
        else {
            return ""
        }

        return fileContents
    }
    
    func getPerson(from jsonData: Data) -> Person? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Person.self, from: jsonData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

let jsonManager = JSONManager()

let content = jsonManager.readFromFile(name: "person")
let jsonData = Data(content.utf8)

if let person = jsonManager.getPerson(from: jsonData) {
    print(person.name)
    print(person.isWorking)
    print(person.address)
}

struct Person: Decodable {
    let name: String
    let age: Int
    let isWorking: Bool
    let email: String?
    let address: Address
}

extension Person {
    
    enum CodingKeys: String, CodingKey  {
        case name, age, email, address
        case isWorking = "is_working"
    }
}

struct Address: Decodable {
    let city: String
    let postalCode: String
    let country: String
}

extension Address {
    enum CodingKeys: String, CodingKey {
        case city, country
        case postalCode = "postal_code"
    }
}
