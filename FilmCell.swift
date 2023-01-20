
import UIKit

class FilmCell: UITableViewCell {
    
    private var film: FilmModel.Film?
    @IBOutlet private var name: UILabel!
    @IBOutlet private var director: UILabel!
    @IBOutlet private var year: UILabel!
    @IBOutlet private var assessment: Assessment!
    
    private var numberOfSections = 0
    
    public func setup(film: FilmModel.Film) {
        self.film = film
        self.name.text = film.name
        self.director.text = film.director
        self.year.text = film.year
        assessment.setStars(film.mark)
    }
    
    @IBAction func markChanged() {
        film?.mark = assessment.mark
    }
    
}
