import UIKit

class MorningLogViewController: UIViewController {
    // MARK: - Properties
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    let sleepPicker = UIPickerView()
    let numberOptions = Array(0...24)

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
    }
    var checkinViewController: CheckinViewController?
    


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
        // Title Label

        // Questions
        contentStackView.addArrangedSubview(createSingleChoiceQuestion("How does your skin feel this morning?", options: ["Normal", "Dry", "Oily", "Combination"]))
        contentStackView.addArrangedSubview(createSingleChoiceQuestion("Did you notice any new breakouts or blemishes today?", options: ["Yes", "No"]))

        // Sleep Picker
        addPickerQuestion("How many hours of sleep did you get last night?")

        // Well-Being Question
        contentStackView.addArrangedSubview(createSingleChoiceQuestion("How well-rested do you feel this morning?", options: ["Good", "Bad", "Neutral", "Energised"]))

        // Text Field
        let textQuestionLabel = UILabel()
        textQuestionLabel.text = "Did you notice any progress in the areas you're targeting?"
        textQuestionLabel.textColor = UIColor(hex: "#3E4040")
        textQuestionLabel.font = UIFont.systemFont(ofSize: 16)
        contentStackView.addArrangedSubview(textQuestionLabel)

        let textField = UITextField()
        textField.placeholder = "Type your answer..."
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(hex: "#D5D5D5").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        contentStackView.addArrangedSubview(textField)

        // Slider Question
        let happinessContainer = UIStackView()
        happinessContainer.axis = .vertical
        happinessContainer.spacing = 10

        let happinessLabel = UILabel()
        happinessLabel.text = "How happy are you with your skin today?"
        happinessLabel.textColor = UIColor(hex: "#3E4040")
        happinessLabel.font = UIFont.systemFont(ofSize: 16)
        happinessLabel.numberOfLines = 0
        happinessContainer.addArrangedSubview(happinessLabel)

        // Slider with Emojis
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
        slider.value = 5 // Default value
        slider.translatesAutoresizingMaskIntoConstraints = false
        sliderContainer.addArrangedSubview(slider)

        let happyEmojiLabel = UILabel()
        happyEmojiLabel.text = "😊"
        sliderContainer.addArrangedSubview(happyEmojiLabel)

        happinessContainer.addArrangedSubview(sliderContainer)

        let sliderValueLabel = UILabel()
        sliderValueLabel.text = "5" // Default value displayed
        sliderValueLabel.textColor = UIColor(hex: "#3E4040")
        sliderValueLabel.font = UIFont.systemFont(ofSize: 14)
        sliderValueLabel.textAlignment = .center
        sliderValueLabel.tag = 200 // Unique tag to identify the label
        happinessContainer.addArrangedSubview(sliderValueLabel)

        slider.addTarget(self, action: #selector(happinessSliderChanged(_:)), for: .valueChanged)

        contentStackView.addArrangedSubview(happinessContainer)

        // Submit Button
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor(hex: "#F28D86")
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.layer.cornerRadius = 22.5 // Capsule shape (half of height)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        contentStackView.addArrangedSubview(submitButton)

        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 45),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor)
        ])
    }

    private func createSingleChoiceQuestion(_ question: String, options: [String]) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10

        let label = UILabel()
        label.text = question
        label.textColor = UIColor(hex: "#3E4040")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        container.addArrangedSubview(label)

        // Stack for rows of buttons
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 10
        buttonStack.tag = 100 // To identify as a group for deselection logic
        container.addArrangedSubview(buttonStack)

        var currentRow: UIStackView?

        for (index, option) in options.enumerated() {
            if index % 2 == 0 {
                // Start a new row every two buttons
                currentRow = UIStackView()
                currentRow?.axis = .horizontal
                currentRow?.spacing = 10
                currentRow?.distribution = .fillEqually
                buttonStack.addArrangedSubview(currentRow!)
            }

            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(UIColor(hex: "#3E4040"), for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "#F28D86").cgColor
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(optionSelectedSingle(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 180),
                button.heightAnchor.constraint(equalToConstant: 45)
            ])

            currentRow?.addArrangedSubview(button)
        }

        return container
    }

    private func addPickerQuestion(_ question: String) {
        let label = UILabel()
        label.text = question
        label.textColor = UIColor(hex: "#3E4040")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        contentStackView.addArrangedSubview(label)

        sleepPicker.dataSource = self
        sleepPicker.delegate = self
        sleepPicker.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(sleepPicker)

        NSLayoutConstraint.activate([
            sleepPicker.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func customizeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#F8F8F8") // Navigation bar background color
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#3E4040"), // Title color
            .font: UIFont.boldSystemFont(ofSize: 26) // Title font
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(hex: "#F28D86") // Back button color

        // Set the navigation bar title
        self.title = "Morning Log"
    }

    // MARK: - Actions
    @objc private func optionSelectedSingle(_ sender: UIButton) {
        guard let buttonStack = sender.superview?.superview as? UIStackView else { return }
        for case let row as UIStackView in buttonStack.arrangedSubviews {
            for case let button as UIButton in row.arrangedSubviews {
                button.backgroundColor = .white
                button.setTitleColor(UIColor(hex: "#3E4040"), for: .normal)
            }
        }
        sender.backgroundColor = UIColor(hex: "#F28D86")
        sender.setTitleColor(.white, for: .normal)
    }
    

    @objc private func happinessSliderChanged(_ sender: UISlider) {
        if let valueLabel = contentStackView.viewWithTag(200) as? UILabel {
            valueLabel.text = String(format: "%.0f", sender.value)
        }
    }

    @objc private func handleSubmit() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let checkinVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                navigationController?.pushViewController(checkinVC, animated: true)
            }
        }
    
}

// MARK: - Picker DataSource and Delegate
extension MorningLogViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberOptions[row])"
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
