import UIKit

extension UIViewController
{
    
    func showOkAlert(title: String?, text: String?, completion: (() -> Void)?)
    {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func showAlert(title: String?, text: String?, dispose_timer: DispatchTime, completion_handler: (() -> Void)?)
    {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: completion_handler)
        DispatchQueue.main.asyncAfter(deadline: dispose_timer, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //keyboard handlers
    
    func removeKeyboardObservers()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initializeKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        //Изменить алгоритм поднятия!!!!
        guard let ns_keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let ns_keyboardRect_other = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardHeight = max(ns_keyboardRect.cgRectValue.height, ns_keyboardRect_other.cgRectValue.height)
        let difference = -keyboardHeight
        self.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(difference))
    }
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }

    func initializeKeyboardHideGestures()
    {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardAction))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardAction() {
        view.endEditing(true)
    }
}
