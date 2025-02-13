import UIKit

class NightLogViewController: UIViewController {
    // MARK: - Properties
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScrollView()
        setupContent()
        customizeNavigationBar()
    }

    private func setupView() {
        view.backgroundColor = UIColor(hex: "#F8F8F8")
        title = "Night Log"
    }

    private func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#F8F8F8")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#3E4040"),
            .font: UIFont.boldSystemFont(ofSize: 26)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(hex: "#F28D86")
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func setupContent() {
        contentStackView.addArrangedSubview(createQuestion("How does your skin feel throughout the day?", options: ["Normal", "Dry", "Oily", "Combination"]))
        contentStackView.addArrangedSubview(createQuestion("How would you describe your skin’s overall appearance tonight?", options: ["Glowing", "Dull", "Inflamed", "Healthy"]))
        contentStackView.addArrangedSubview(createTextQuestion("How much water did you drink today?"))
        contentStackView.addArrangedSubview(createQuestion("Did your diet today include anything that might impact your skin?", options: ["Sugar", "Caffeine", "Dairy", "Processed"]))
        contentStackView.addArrangedSubview(createTextQuestion("How much time did you spend outdoors or exposed to the sun?"))
        contentStackView.addArrangedSubview(createQuestion("Did environmental factors impact your skin today?", options: ["Pollution", "Humidity", "Air conditioning", "Heat"]))
        contentStackView.addArrangedSubview(createQuestion("Are you planning to sleep early tonight?", options: ["Yes", "No"]))
        contentStackView.addArrangedSubview(createSliderQuestion("How satisfied are you with your skin today?"))

        // Submit Button
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        submitButton.backgroundColor = UIColor(hex: "#F28D86")
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22.5 // Capsule shape (half of 45)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside) // **Fix: Add target**

        contentStackView.addArrangedSubview(submitButton)

        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 45),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor)
        ])
    }

    private func createQuestion(_ question: String, options: [String]) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10

        // Question Label
        let label = UILabel()
        label.text = question
        label.textColor = UIColor(hexString: "#3E4040")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        container.addArrangedSubview(label)

        // Button Stack
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 10

        for rowOptions in stride(from: 0, to: options.count, by: 2) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually

            for i in rowOptions..<min(rowOptions + 2, options.count) {
                let button = UIButton(type: .system)
                button.setTitle(options[i], for: .normal)
                button.setTitleColor(UIColor(hexString: "#3E4040"), for: .normal)
                button.backgroundColor = .white
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(hexString: "#F28D86").cgColor
                button.layer.cornerRadius = 8
                button.translatesAutoresizingMaskIntoConstraints = false

                // Set fixed size for the button
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: 180),
                    button.heightAnchor.constraint(equalToConstant: 45)
                ])

                button.addTarget(self, action: #selector(optionSelectedSingle(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }

            buttonStack.addArrangedSubview(rowStack)
        }

        container.addArrangedSubview(buttonStack)
        return container
    }


    private func createTextQuestion(_ question: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10

        let label = UILabel()
        label.text = question
        label.textColor = UIColor(hex: "#3E4040")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        container.addArrangedSubview(label)

        let textField = UITextField()
        textField.placeholder = "Type your answer..."
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: "#D5D5D5").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        container.addArrangedSubview(textField)

        return container
    }

    private func createSliderQuestion(_ question: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10

        let label = UILabel()
        label.text = question
        label.textColor = UIColor(hex: "#3E4040")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        container.addArrangedSubview(label)

        let sliderContainer = UIStackView()
        sliderContainer.axis = .horizontal
        sliderContainer.spacing = 10
        sliderContainer.alignment = .center

        let sadEmojiLabel = UILabel()
        sadEmojiLabel.text = "😔"
        sliderContainer.addArrangedSubview(sadEmojiLabel)

        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.tintColor = UIColor(hex: "#F28D86")
        sliderContainer.addArrangedSubview(slider)

        let happyEmojiLabel = UILabel()
        happyEmojiLabel.text = "😊"
        sliderContainer.addArrangedSubview(happyEmojiLabel)

        container.addArrangedSubview(sliderContainer)
        return container
    }

    // MARK: - Actions
    @objc private func optionSelectedSingle(_ sender: UIButton) {
        guard let questionContainer = sender.superview?.superview as? UIStackView else { return }

        for case let rowStack as UIStackView in questionContainer.arrangedSubviews {
            for case let button as UIButton in rowStack.arrangedSubviews {
                button.backgroundColor = .white
                button.setTitleColor(UIColor(hex: "#3E4040"), for: .normal)
            }
        }

        sender.backgroundColor = UIColor(hex: "#F28D86")
        sender.setTitleColor(.white, for: .normal)
    }
    @objc private func handleSubmit() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let checkinVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                navigationController?.pushViewController(checkinVC, animated: true)
            }
        }
}

extension UIColor {
    convenience init(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
