import UIKit

class FilmModel: NSObject, UITableViewDataSource {
    
    class Film: Equatable {
        static func == (lhs: FilmModel.Film, rhs: FilmModel.Film) -> Bool {
            return lhs.name == rhs.name && lhs.director == rhs.director && lhs.year == rhs.year
        }
        
        var name: String
        var director: String
        var year: String
        var mark: Int
        init(_ name: String, _ director: String, _ year: String, _ mark: Int) {
            self.name = name
            self.director = director
            self.year = year
            self.mark = mark
        }
        
    }
    
    public var films: [Film]
    public var year: [String] = []
    public var filmsInYear: [String : [Film]] = [:]
    
    init(_ films: [Film]) {
        self.films = films
        super.init()
        films.forEach({film in
            if filmsInYear[film.year] == nil {
                filmsInYear[film.year] = []
            }
            filmsInYear[film.year]?.append(film)
        })
        year = Array(filmsInYear.keys).sorted()
    }
    
    func addFilm(film: Film, table: UITableView) {
        self.films.append(film)
        if !year.contains(film.year) {
            year.append(film.year)
            year.sort()
            filmsInYear[film.year] = []
            table.insertSections([year.firstIndex(of: film.year) ?? 0], with: .automatic)
        }
        filmsInYear[film.year]?.append(film)
        table.insertRows(
            at: [IndexPath(
                row: (filmsInYear[film.year]?.count ?? 0) - 1,
                section: year.firstIndex(of: film.year) ?? 0
            )],
            with: .automatic
        )
    }
    
    func deleteFilm(index: IndexPath, table: UITableView) {
        films.remove(at: films.firstIndex(of: filmsInYear[year[index.section]]![index.row]) ?? 0)
        filmsInYear[year[index.section]]?.remove(at: index.row)
        table.deleteRows(at: [index], with: .automatic)
        if filmsInYear[year[index.section]]?.count == 0 {
            filmsInYear.removeValue(forKey: year[index.section])
            year.remove(at: index.section)
            table.deleteSections([index.section], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filmsInYear[year[section]]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return year.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell") as? FilmCell
        else { return UITableViewCell() }
        cell.setup(film: filmsInYear[year[indexPath.section]]![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        year[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        year
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        index
    }
}
