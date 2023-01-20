import UIKit

protocol InputFilmDelegate {
    func addFilm(film: FilmModel.Film)
}

class InputFilm: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Фильм"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var name: Container = Container(
        frame: CGRect(),
        text: "Название",
        placeholder: "Название фильма",
        validation: {
            (self) -> Bool in
            return (self.textField.text?.count ?? 0) >= 1 && (self.textField.text?.count ?? 0) <= 300
        }
    )
    
    private lazy var director: Container = Container(
        frame: CGRect(),
        text: "Режисёр",
        placeholder: "Режисёр фильма",
        validation: {
            (self) -> Bool in
            return (self.textField.text?.count ?? 0) >= 3 &&
            (self.textField.text?.count ?? 0) <= 300 &&
            self.textField.text?.range(of: "^([A-ZА-Я][A-ZА-Яa-zа-я]* *)+$", options: .regularExpression) != nil
        }
    )
    
    private lazy var year: Container = Container(
        frame: CGRect(),
        text: "Год",
        placeholder: "Год выпуска",
        validation: {
            (self) -> Bool in
            return !(self.textField.text == nil)
        }
    )
    
    private lazy var assessment: Assessment = Assessment()
    
    private lazy var labelAssessment:UILabel = {
        let label = UILabel()
        label.text = "Ваша оценка"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = UIDatePicker()
    
    private lazy var randomButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Рандомные значения", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 93/255, green: 176/255, blue: 117/255, alpha: 1)
        button.layer.cornerRadius = 25.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(randomData), for: .touchDown)
        return button
    }()
    
    private var mark = [0: "Ужасно", 1: "Плохо", 2: "Нормально", 3: "Хорошо", 4: "AMAZING!"]
    
    private lazy var save: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 93/255, green: 176/255, blue: 117/255, alpha: 1)
        button.layer.cornerRadius = 25.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer.opacity = 0.4
        button.addTarget(self, action: #selector(saveData), for: .touchDown)
        return button
    }()
    
    public var pparent: InputFilmDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(name)
        view.addSubview(director)
        view.addSubview(year)
        view.addSubview(assessment)
        view.addSubview(labelAssessment)
        view.addSubview(save)
        view.addSubview(randomButton)
        
        year.textField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(doneAction))
        toolbar.setItems([doneButton], animated: true)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        year.textField.inputAccessoryView = toolbar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
       
        view.addGestureRecognizer(tapGesture)
                
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        assessment.translatesAutoresizingMaskIntoConstraints = false
        
        name.addTarget(self, action: #selector(containerDidChange), for: .allEvents)
        director.addTarget(self, action: #selector(containerDidChange), for: .allEvents)
        year.addTarget(self, action: #selector(containerDidChange), for: .allEvents)
        assessment.addTarget(self, action: #selector(containerDidChange), for: .allEvents)
        

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 36),
            
            name.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            director.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 16),
            director.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            director.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            year.topAnchor.constraint(equalTo: director.bottomAnchor, constant: 16),
            year.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            year.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            assessment.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 40),
            assessment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            assessment.widthAnchor.constraint(equalToConstant: 250),
            
            labelAssessment.topAnchor.constraint(equalTo: assessment.bottomAnchor, constant: 20),
            labelAssessment.heightAnchor.constraint(equalToConstant: 19),
            labelAssessment.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            save.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            save.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            save.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            save.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            save.heightAnchor.constraint(equalToConstant: 51),
            
            randomButton.bottomAnchor.constraint(equalTo: save.topAnchor, constant: -32),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            randomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            randomButton.heightAnchor.constraint(equalToConstant: 51)
        ])
    }
    
    @objc private func containerDidChange() {
        if (assessment.isSelected) {
            labelAssessment.text = mark[assessment.mark]
        }
        if name.isSelected && director.isSelected && year.isSelected && assessment.isSelected {
            save.isEnabled = true
            save.layer.opacity = 1
        } else {
            save.isEnabled = false
            save.layer.opacity = 0.4
        }
    }
    
    @objc private func randomData() {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "1234567890"
        name.textField.text = String((0..<Int.random(in: 1...50)).map{ _ in letters.randomElement()! })
        director.textField.text = String((0..<Int.random(in: 1...100)).map{ _ in letters.randomElement()! })        
        setDate(Date(timeIntervalSince1970: Double.random(in: 1...Date().timeIntervalSince1970)))
        
        let number = Int.random(in: 0...4)
        name.isSelected = true
        year.isSelected = true
        director.isSelected = true
        assessment.isSelected = true
        assessment.stars[number].sendActions(for: .touchDown)
        
    }
    
    @objc func doneAction() {
            view.endEditing(true)
        }
        
    @objc func tapGestureDone() {
            view.endEditing(true)
        }
        
    private func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        year.textField.text = formatter.string(from: date)
        year.isSelected = true
        year.sendActions(for: .allEvents)
    }
    
    @objc func dateChanged() {
        setDate(datePicker.date)
    }
    
    @objc func saveData() {
        guard let newName = name.textField.text else { return }
        guard let newDirector = director.textField.text else { return }
        guard let newData = year.textField.text else { return }
        let newYear = newData[newData.index(after: newData.lastIndex(of: ".") ?? newData.index(before: newData.startIndex))...]
        let film = FilmModel.Film(newName, newDirector, String(newYear), assessment.mark)
        pparent?.addFilm(film: film)
        self.navigationController?.popViewController(animated: true)
    }
}
