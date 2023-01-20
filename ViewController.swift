
import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var add: UIButton!
    
    private var data = FilmModel([FilmModel.Film("Titanic", "James Cameron", "1997", 3),
                                  FilmModel.Film("AmericanPsyho", "Mary Harron", "2000", 1),
                                  FilmModel.Film("film1", "producer1", "1997", 1),
                                  FilmModel.Film("film2", "producer2", "1991", 1),
                                  FilmModel.Film("film3", "producer3", "1991", 1),
                                  FilmModel.Film("film4", "producer", "1991", 1),
                                  FilmModel.Film("film5", "producer", "1990", 1),
                                  FilmModel.Film("film6", "producer", "1991", 1)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = data
        tableView.delegate = self
        tableView.register(UINib(nibName: "FilmCell", bundle: nil), forCellReuseIdentifier: "FilmCell")
        tableView.sectionIndexColor = UIColor(red: 93/255, green: 176/255, blue: 117/255, alpha: 1)
    }
    
    @IBAction func onButtonPress(_ sender: UIButton) {
        let filmPage = InputFilm()
        filmPage.pparent = self
        self.navigationController?.pushViewController(filmPage, animated: true)
    }
}

extension ViewController: UITableViewDelegate, InputFilmDelegate {
    func addFilm(film: FilmModel.Film) {
        data.addFilm(film: film, table: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [UIContextualAction(
                style: .destructive,
                title: "Удалить",
                handler: { [self] (action, view, completionHandler)
                    in self.data.deleteFilm(index: indexPath, table: self.tableView); completionHandler(true)
                }
            )]
        )
    }

}


