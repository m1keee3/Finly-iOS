import UIKit

final class LoginViewController: UIViewController {

    private let viewModel: AuthViewModelProtocol

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .interactive
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chart.line.uptrend.xyaxis"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = DS.Colors.accent
        iv.contentMode = .scaleAspectFit
        iv.accessibilityIdentifier = "auth_logo"
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Finly"
        l.apply(.largeTitle)
        l.textAlignment = .center
        l.accessibilityIdentifier = "auth_title"
        return l
    }()

    private let emailField = DSTextField(config: FormFieldConfig(
        title: "Email",
        placeholder: "Email",
        keyboardType: .emailAddress,
        isSecure: false,
        returnKeyType: .next,
        accessibilityIdentifier: "auth_email_field"
    ))

    private let passwordField = DSTextField(config: FormFieldConfig(
        title: "Пароль",
        placeholder: "Пароль",
        keyboardType: .default,
        isSecure: true,
        returnKeyType: .done,
        accessibilityIdentifier: "auth_password_field"
    ))

    private let generalErrorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = DS.Typography.caption()
        l.textColor = DS.Colors.destructive
        l.textAlignment = .center
        l.numberOfLines = 0
        l.isHidden = true
        l.accessibilityIdentifier = "auth_general_error"
        return l
    }()

    private let loginButton: DSButton = {
        let b = DSButton(style: .primary, title: "Войти")
        b.accessibilityIdentifier = "auth_login_button"
        return b
    }()

    private let telegramButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Войти через Telegram"
        config.image = UIImage(systemName: "paperplane.fill")
        config.imagePadding = 8
        config.cornerStyle = .large
        config.buttonSize = .large
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.accessibilityIdentifier = "auth_telegram_button"
        return b
    }()

    private let registerButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Зарегистрироваться"
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.accessibilityIdentifier = "auth_register_button"
        return b
    }()

    private let dividerView = DividerView(text: "или")

    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupHierarchy()
        setupConstraints()
        setupActions()
        setupDelegates()
        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func setupAppearance() {
        view.backgroundColor = DS.Colors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            logoImageView,
            titleLabel,
            emailField,
            passwordField,
            generalErrorLabel,
            loginButton,
            dividerView,
            telegramButton,
            registerButton
        ].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        let h: CGFloat = DS.Spacing.xl

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor
            ),

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.fieldHeight),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 64),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: DS.Spacing.l),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),

            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DS.Spacing.xxxl),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: DS.Spacing.xl),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),

            generalErrorLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: DS.Spacing.xl),
            generalErrorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            generalErrorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),

            loginButton.topAnchor.constraint(equalTo: generalErrorLabel.bottomAnchor, constant: DS.Spacing.m),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            loginButton.heightAnchor.constraint(equalToConstant: DS.Spacing.fieldHeight),

            dividerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: DS.Spacing.xl),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            dividerView.heightAnchor.constraint(equalToConstant: 20),

            telegramButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: DS.Spacing.l),
            telegramButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            telegramButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            telegramButton.heightAnchor.constraint(equalToConstant: DS.Spacing.fieldHeight),

            registerButton.topAnchor.constraint(equalTo: telegramButton.bottomAnchor, constant: DS.Spacing.m),
            registerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registerButton.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -DS.Spacing.xxl
            ),
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        telegramButton.addTarget(self, action: #selector(telegramTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        emailField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    private func setupDelegates() {
        emailField.textField.delegate = self
        passwordField.textField.delegate = self
    }

    @objc private func loginTapped() {
        dismissKeyboard()
        viewModel.didTapLoginWithEmail(
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }

    @objc private func telegramTapped() {
        viewModel.didTapLoginWithTelegram()
    }

    @objc private func registerTapped() {
        viewModel.didTapRegister()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func emailChanged() {
        viewModel.didChangeEmail(emailField.text ?? "")
    }

    @objc private func passwordChanged() {
        viewModel.didChangePassword(passwordField.text ?? "")
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo    = notification.userInfo,
            let endFrame    = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration    = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw    = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let converted    = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(converted)
        let bottomInset  = intersection.height > 0 ? intersection.height : 0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .init(rawValue: curveRaw << 16)
        ) {
            self.scrollView.contentInset.bottom = bottomInset
            self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }
}

// MARK: - AuthView

extension LoginViewController: AuthView {

    func render(_ state: AuthViewState) {
        loginButton.setLoading(state.isLoading)
        loginButton.isEnabled = !state.isLoading
        emailField.isEnabled = !state.isLoading
        passwordField.isEnabled = !state.isLoading

        if let emailError = state.emailError {
            emailField.showError(emailError)
        } else {
            emailField.clearError()
            if emailField.textField.isEditing {
                emailField.setHighlight(.focused)
            }
        }

        if let passwordError = state.passwordError {
            passwordField.showError(passwordError)
        } else {
            passwordField.clearError()
            if passwordField.textField.isEditing {
                passwordField.setHighlight(.focused)
            }
        }

        if let message = state.errorMessage {
            if state.showErrorAsAlert {
                generalErrorLabel.isHidden = true
                generalErrorLabel.text = nil
                showAlert(message: message)
            } else {
                generalErrorLabel.text = message
                generalErrorLabel.isHidden = false
                emailField.setHighlight(.error)
                passwordField.setHighlight(.error)
            }
        } else {
            generalErrorLabel.isHidden = true
            generalErrorLabel.text = nil
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Уведомление",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel.didShowAlert()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField.textField {
            passwordField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginTapped()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let field = textField == emailField.textField ? emailField : passwordField
        field.setHighlight(.focused)
        generalErrorLabel.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let field = textField == emailField.textField ? emailField : passwordField
        field.setHighlight(.normal)
    }
}
