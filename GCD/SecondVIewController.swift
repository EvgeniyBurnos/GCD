//
//  SecondVIewController.swift
//  GCD
//
//  Created by Евгений Бурнос on 16.01.2023.
//

import UIKit

class SecondViewController: ViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activiteIndicator: UIActivityIndicatorView!

    fileprivate var imageURL: URL?
    fileprivate var image: UIImage?{
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            activiteIndicator.stopAnimating()
            activiteIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        delay(3) {
            self.loginAlert()
        }
    }
//    MARK: - задержка
    fileprivate func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
//    MARK: - Alert
    fileprivate func loginAlert() {
        let ac = UIAlertController(title: "Зарегестрированы?", message: "Введите ваш логин и пароль", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        ac.addTextField { (userNameTF) in
            userNameTF.placeholder = "Введите логин"
        }
        ac.addTextField { (userPasswordTF) in
            userPasswordTF.placeholder = "Введите пароль"
            userPasswordTF.isSecureTextEntry = true
        }
        self.present(ac, animated: true)
    }
//    MARK: - Api with GCD
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://avatarko.ru/img/kartinka/33/multfilm_lyagushka_32117.jpg")
        activiteIndicator.isHidden = false
        activiteIndicator.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
    }
    
}
