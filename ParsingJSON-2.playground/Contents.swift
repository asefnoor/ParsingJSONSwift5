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
    
    func getPerson(from jsonData: Data) -> [Person]? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Person].self, from: jsonData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

let jsonManager = JSONManager()

let content = jsonManager.readFromFile(name: "employee")
let jsonData = Data(content.utf8)

if let person = jsonManager.getPerson(from: jsonData)?.first {
    print(person.name)
}

struct Person: Decodable {
    let name: String
    let age: Int
    let isWorking: Bool
    let email: String?
    let currentCity: String
    let previousCity: String
    let website: String
    let twitterHandle: String
    
}

extension Person {
    
    enum CodingKeys: String, CodingKey  {
        case name, age, email, website
        
        case isWorking = "is_working"
        case currentCity = "current_city"
        case previousCity = "previous_city"
        case twitterHandle = "twitter"
        
    }
    
    enum CurrentCityCodingKeys: String, CodingKey {
        case city
    }
    
    enum PreviousCityCodingKeys: String, CodingKey {
        case name
    }
    
    enum WebsiteCodingKeys: String, CodingKey {
        case link
    }
    
    enum TwitterCodingKeys: String, CodingKey {
        case handle
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        email = try container.decode(String.self, forKey: .email)
        isWorking = try container.decode(Bool.self, forKey: .isWorking)
    
        let currentCityContainer = try container.nestedContainer(keyedBy: CurrentCityCodingKeys.self, forKey: .currentCity)
        currentCity = try currentCityContainer.decode(String.self, forKey: .city)
        
        let previousCityContainer = try container.nestedContainer(keyedBy: PreviousCityCodingKeys.self, forKey: .previousCity)
        previousCity = try previousCityContainer.decode(String.self, forKey: .name)
        
        let websiteContainer = try container.nestedContainer(keyedBy: WebsiteCodingKeys.self, forKey: .website)
        website = try websiteContainer.decode(String.self, forKey: .link)
        
        let twitterHandleContainer = try container.nestedContainer(keyedBy: TwitterCodingKeys.self, forKey: .twitterHandle)
        twitterHandle = try twitterHandleContainer.decode(String.self, forKey: .handle)
        
        
        print(name, age, email!, isWorking, currentCity, website, twitterHandle, previousCity)
        
    }
    
}














