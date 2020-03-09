import Foundation

struct Person: Decodable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: URL
    let films: [URL]
    let species: [URL]
    let vehicles: [URL]
    let starships: [URL]
    let created: String
    let edited: String
    let url: URL
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService: Decodable {
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent("people")
        let realFinalURL = finalURL.appendingPathComponent("\(id)")
        print(realFinalURL)
        // 2 - Contact server
        URLSession.shared.dataTask(with: realFinalURL) { (data, _, error) in
            
            // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // 4 - Check for data
            guard let data = data else {return completion(nil)}
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            // 5 - Decode Person from JSON
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            // 3 - Check for data
            guard let data = data else {return completion(nil)}
            
            // 4 - Decode Film from JSON
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
}//End of class
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        print(person.films)
        for film in person.films {
            fetchFilm(url: film)
        }
        
    }
}
fetchFilm(url: URL(string: "https://swapi.co/api/films/3/")!)
