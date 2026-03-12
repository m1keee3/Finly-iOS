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
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.accessibilityIdentifier = "auth_logo"
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Finly"
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textAlignment = .center
        l.accessibilityIdentifier = "auth_title"
        return l
    }()

    private let emailContainerView = TextFieldContainerView()

    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        tf.font = .systemFont(ofSize: 16)
        tf.isUserInteractionEnabled = true
        tf.accessibilityIdentifier = "auth_email_field"
        return tf
    }()

    private let emailErrorLabel = InlineErrorLabel()

    private let passwordContainerView = TextFieldContainerView()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        tf.font = .systemFont(ofSize: 16)
        tf.isUserInteractionEnabled = true
        tf.accessibilityIdentifier = "auth_password_field"
        return tf
    }()

    private let passwordErrorLabel = InlineErrorLabel()

    private let generalErrorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14)
        l.textColor = .systemRed
        l.textAlignment = .center
        l.numberOfLines = 0
        l.isHidden = true
        l.accessibilityIdentifier = "auth_general_error"
        return l
    }()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Войти"
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .large
        config.buttonSize = .large
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.accessibilityIdentifier = "auth_login_button"
        return b
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.color = .white
        return ai
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
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            logoImageView,
            titleLabel,
            emailContainerView,
            emailErrorLabel,
            passwordContainerView,
            passwordErrorLabel,
            generalErrorLabel,
            loginButton,
            dividerView,
            telegramButton,
            registerButton
        ].forEach { contentView.addSubview($0) }

        emailContainerView.addTextField(emailTextField)
        passwordContainerView.addTextField(passwordTextField)

        loginButton.addSubview(activityIndicator)
    }

    private func setupConstraints() {
        let h: CGFloat = 24
        let fh: CGFloat = 52

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

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 52),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 64),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),

            emailContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            emailContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            emailContainerView.heightAnchor.constraint(equalToConstant: fh),

            emailErrorLabel.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 4),
            emailErrorLabel.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 4),
            emailErrorLabel.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor),

            passwordContainerView.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 24),
            passwordContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            passwordContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            passwordContainerView.heightAnchor.constraint(equalToConstant: fh),

            passwordErrorLabel.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 4),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 4),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor),

            generalErrorLabel.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 24),
            generalErrorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            generalErrorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),

            loginButton.topAnchor.constraint(equalTo: generalErrorLabel.bottomAnchor, constant: 12),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            loginButton.heightAnchor.constraint(equalToConstant: fh),

            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),

            dividerView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            dividerView.heightAnchor.constraint(equalToConstant: 20),

            telegramButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            telegramButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: h),
            telegramButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -h),
            telegramButton.heightAnchor.constraint(equalToConstant: fh),

            registerButton.topAnchor.constraint(equalTo: telegramButton.bottomAnchor, constant: 12),
            registerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registerButton.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -32
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

        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc private func loginTapped() {
        dismissKeyboard()
        viewModel.didTapLoginWithEmail(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
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
        viewModel.didChangeEmail(emailTextField.text ?? "")
    }

    @objc private func passwordChanged() {
        viewModel.didChangePassword(passwordTextField.text ?? "")
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

extension LoginViewController: AuthView {

    func render(_ state: AuthViewState) {
        loginButton.isEnabled       = !state.isLoading
        emailTextField.isEnabled    = !state.isLoading
        passwordTextField.isEnabled = !state.isLoading

        if state.isLoading {
            activityIndicator.startAnimating()
            loginButton.configuration?.title = ""
        } else {
            activityIndicator.stopAnimating()
            loginButton.configuration?.title = "Войти"
        }

        if let emailError = state.emailError {
            emailErrorLabel.show(emailError)
            emailContainerView.setHighlight(.error)
        } else {
            emailErrorLabel.hide()
            if emailTextField.isEditing {
                emailContainerView.setHighlight(.focused)
            } else {
                emailContainerView.setHighlight(.normal)
            }
        }

        if let passwordError = state.passwordError {
            passwordErrorLabel.show(passwordError)
            passwordContainerView.setHighlight(.error)
        } else {
            passwordErrorLabel.hide()
            if passwordTextField.isEditing {
                passwordContainerView.setHighlight(.focused)
            } else {
                passwordContainerView.setHighlight(.normal)
            }
        }

        if let message = state.errorMessage {
            if state.showErrorAsAlert {
                generalErrorLabel.isHidden = true
                generalErrorLabel.text = nil
                showAlert(message: message)
            } else {
                generalErrorLabel.text     = message
                generalErrorLabel.isHidden = false
                emailContainerView.setHighlight(.error)
                passwordContainerView.setHighlight(.error)
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

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginTapped()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let container = textField == emailTextField ? emailContainerView : passwordContainerView
        container.setHighlight(.focused)
        generalErrorLabel.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let container = textField == emailTextField ? emailContainerView : passwordContainerView
        container.setHighlight(.normal)
    }
}
