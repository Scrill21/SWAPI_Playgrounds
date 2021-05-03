import UIKit

struct Person: Decodable {
    let name: String
    let films: [String]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // Step 1: Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let peopleURL = baseURL.appendingPathComponent("people")
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        // Step 2: Contact server
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            //Step 3: Handle the error
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(nil)
            }
            
            //Step 4: Check for Data
            guard let data = data else {return completion(nil)}
            
            //Step 5: Decode
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error: \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: String, completion: @escaping (Film?) -> Void) {
        //Step 1: Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let filmsURL = baseURL.appendingPathComponent("films/1")
        
        //Step 2: Contact Server
        URLSession.shared.dataTask(with: filmsURL) { data, _, error in
            //Step 3: Handle the error
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(nil)
            }
            
            //Step 4: Check for Data
            guard let data = data else {return completion(nil)}
            
            //Step 5: Decode
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error: \(error.localizedDescription)")
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: String) {
        SwapiService.fetchFilm(url: url) { film in
            if let film = film {
                print(film)
            }
        }
    }
}//End of class

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        for film in person.films {
            SwapiService.fetchFilm(url: film)
        }
    }
}
