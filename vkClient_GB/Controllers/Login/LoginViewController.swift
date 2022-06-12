//
//  ViewController.swift
//  VKClient
//
//  Created by Дмитрий Скок on 23.08.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var backView: UIView!
    @IBOutlet var dot1: UIView!
    @IBOutlet var dot2: UIView!
    @IBOutlet var dot3: UIView!
    
    var likeEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dotsAnimation()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.view.addGestureRecognizer(tapRecognizer)
        addShadow(view: loginTextField)
        addShadow(view: passwordTextField)
        addShadow(view: loginButton)
        loginButton.layer.cornerRadius = 10
        dot1.layer.cornerRadius = CGFloat(30 / 2)
        dot2.layer.cornerRadius = CGFloat(30 / 2)
        dot3.layer.cornerRadius = CGFloat(30 / 2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemRed.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func tapFunction() {
        self.view.endEditing(true)
    }
    
    @IBAction func pressHeartButton(_ sender: Any) {
        guard let button = sender as? UIButton else {return}
        if likeEnable {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        likeEnable = !likeEnable
}
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "moveToMain" {
            
            guard
                let login = loginTextField.text,
                let password = passwordTextField.text
            else {
                print("login or password eqal nil")
                showErrorAlert(message: "Поля не заполнены")
                return false
            }
            
            if login == "1" && password == "1" {
                loginTextField.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                passwordTextField.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                print("успешная авторизация")
                return true
            } else {
                loginTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                passwordTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                showErrorAlert(message: "Не правильные логин или пароль")
                print("неуспешная авторизация")
                return false
            }
        }
        return false
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print ("loginButtonPressed")
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка",message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func addShadow (view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
    }
}

extension LoginViewController {
    func dotsAnimation() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: [.repeat, .autoreverse]) {[weak self] in
            guard let self = self else {return}
            self.dot1.alpha = 0.1
        } completion: { isSuccessfully in}
        UIView.animate(withDuration: 0.6,
                       delay: 0.2,
                       options: [.repeat, .autoreverse]) {[weak self] in
            guard let self = self else {return}
            self.dot2.alpha = 0.1
        } completion: { isSuccessfully in}
        UIView.animate(withDuration: 0.6,
                       delay: 0.4,
                       options: [.repeat, .autoreverse]) {[weak self] in
            guard let self = self else {return}
            self.dot3.alpha = 0.1
        } completion: { isSuccessfully in}
    }
}
