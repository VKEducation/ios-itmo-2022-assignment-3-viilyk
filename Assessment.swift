
import Foundation
import UIKit

class Assessment: UIControl {
    
    lazy var stars: [UIButton] = {
        var stars: [UIButton] = []
        for i in 0..<5 {
            stars.append(UIButton())
            stars[i].setImage(UIImage(named: "Star.png"), for: .normal)
            stars[i].setImage(UIImage(named: "Union.png"), for: .highlighted)
            stars[i].addTarget(self, action: #selector(didTapButton), for: .touchDown)
            stars[i].translatesAutoresizingMaskIntoConstraints = false
        }
        return stars
    }()
    
     var mark: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initStars()
    }
    
    func initStars() {
        for i in 0..<5 {
            addSubview(stars[i])
        }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            stars[0].widthAnchor.constraint(equalTo: stars[1].widthAnchor),
            stars[1].widthAnchor.constraint(equalTo: stars[2].widthAnchor),
            stars[2].widthAnchor.constraint(equalTo: stars[3].widthAnchor),
            stars[3].widthAnchor.constraint(equalTo: stars[4].widthAnchor),
            stars[0].heightAnchor.constraint(equalTo: stars[0].widthAnchor),
            stars[1].heightAnchor.constraint(equalTo: stars[1].widthAnchor),
            stars[2].heightAnchor.constraint(equalTo: stars[2].widthAnchor),
            stars[3].heightAnchor.constraint(equalTo: stars[3].widthAnchor),
            stars[4].heightAnchor.constraint(equalTo: stars[4].widthAnchor),

            stars[0].topAnchor.constraint(equalTo: topAnchor),
            stars[0].leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stars[1].topAnchor.constraint(equalTo: topAnchor),
            stars[1].leadingAnchor.constraint(equalTo: stars[0].trailingAnchor, constant: stars[1].bounds.size.width / 4),
            
            stars[2].topAnchor.constraint(equalTo: topAnchor),
            stars[2].leadingAnchor.constraint(equalTo: stars[1].trailingAnchor, constant: stars[2].bounds.size.width / 4),
            
            stars[3].topAnchor.constraint(equalTo: topAnchor),
            stars[3].leadingAnchor.constraint(equalTo: stars[2].trailingAnchor, constant: stars[3].bounds.size.width  / 4),
            
            stars[4].topAnchor.constraint(equalTo: topAnchor),
            stars[4].leadingAnchor.constraint(equalTo: stars[3].trailingAnchor, constant: stars[4].bounds.size.width / 4),
            stars[4].trailingAnchor.constraint(equalTo: trailingAnchor),
            stars[4].bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    
    @objc private func didTapButton(_ button: UIButton) {
        var number = 0
        while button != stars[number] {
            number += 1
        }
        setStars(number)
        isSelected = true
        sendActions(for: .allEvents)
    }
    
    func setStars(_ number: Int) {
        for i in 0...number {
            stars[i].setImage(UIImage(named: "Union.png"), for: .normal)
        }
        for i in (number + 1)..<5 {
            stars[i].setImage(UIImage(named: "Star.png"), for: .normal)
        }
        mark = number
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initStars()
    }
}

