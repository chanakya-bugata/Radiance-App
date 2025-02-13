import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6 // Light gray for the screen's background
        setupCalendarSection()
        setupGallerySection()
    }

    // Calendar Section
    func setupCalendarSection() {
        let calendarBackground = UIView()
        calendarBackground.backgroundColor = .white
        calendarBackground.layer.cornerRadius = 10
        calendarBackground.layer.shadowColor = UIColor.black.cgColor
        calendarBackground.layer.shadowOpacity = 0.1
        calendarBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
        calendarBackground.layer.shadowRadius = 4
        calendarBackground.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(calendarBackground)

        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.tintColor = UIColor(hex: "F28D86") // Coral tint for navigation arrows

        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection

        view.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendarBackground.heightAnchor.constraint(equalToConstant: 390),

            calendarView.leadingAnchor.constraint(equalTo: calendarBackground.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: calendarBackground.trailingAnchor, constant: -16),
            calendarView.topAnchor.constraint(equalTo: calendarBackground.topAnchor, constant: 16),
            calendarView.bottomAnchor.constraint(equalTo: calendarBackground.bottomAnchor, constant: -16)
        ])
    }

    // Gallery Section
    func setupGallerySection() {
        let galleryLabel = UILabel()
        galleryLabel.text = "Gallery"
        galleryLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        galleryLabel.translatesAutoresizingMaskIntoConstraints = false

        let navigationIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        navigationIcon.tintColor = UIColor(hex: "F28D86") // Coral color
        navigationIcon.translatesAutoresizingMaskIntoConstraints = false

        let headerStack = UIStackView(arrangedSubviews: [galleryLabel, navigationIcon])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        // Add Tap Gesture Recognizer to the header stack
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
        headerStack.addGestureRecognizer(tapGesture)
        headerStack.isUserInteractionEnabled = true

        view.addSubview(headerStack)

        let image1 = UIImageView(image: UIImage(named: "images"))
        let image2 = UIImageView(image: UIImage(named: "images"))
        [image1, image2].forEach { imageView in
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }

        let imagesStack = UIStackView(arrangedSubviews: [image1, image2])
        imagesStack.axis = .horizontal
        imagesStack.spacing = 20
        imagesStack.alignment = .center
        imagesStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imagesStack)

        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 435),

            imagesStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imagesStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            imagesStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 8)
        ])
    }

    // Action triggered when the gallery section is tapped
    @objc func galleryTapped() {
        print("Gallery section tapped") // Debug log for verification
        if let galleryVC = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController {
            navigationController?.pushViewController(galleryVC, animated: true)
        } else {
            print("GalleryViewController not found in storyboard")
        }
    }
}

extension HistoryViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate,
           selection.selectedDate == dateComponents {
            return .customView {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                view.backgroundColor = UIColor(hex: "FDF1F0")
                view.layer.cornerRadius = 20

                let label = UILabel(frame: view.bounds)
                label.textAlignment = .center
                label.textColor = UIColor(hex: "F28D86")
                label.text = "\(dateComponents.day!)"
                label.font = UIFont.boldSystemFont(ofSize: 16)

                view.addSubview(label)
                return view
            }
        }
        return nil
    }
}

extension HistoryViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else { return }
        print("Date Selected: \(dateComponents)")

        if let completeVC = storyboard?.instantiateViewController(withIdentifier: "CompleteViewController") as? CompleteViewController {
            if let date = Calendar.current.date(from: dateComponents) {
                completeVC.selectedDate = date
            }
            navigationController?.pushViewController(completeVC, animated: true)
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
