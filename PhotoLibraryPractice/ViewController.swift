//
//  ViewController.swift
//  PhotoLibraryPractice
//
//  Created by 坂本龍哉 on 2021/09/10.
//

import UIKit
import Photos

final class ViewController: UIViewController {
    
    @IBOutlet private weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func selectPhotosButtonDidTapped(_ sender: Any) {
        
        getPhotosAuthorization()
        showImagePickerController()
        
    }
    
    private func getPhotosAuthorization() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                break
            case .denied:
                DispatchQueue.main.async {
                    print(status)
                    self.showPhotosAuthorizationDeniedAlert()
                }
            default:
                break
            }
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            dismiss(animated: true,
                    completion: nil)
        }
    }

}


extension ViewController {
    
    private func showPhotosAuthorizationDeniedAlert() {
        let alert = UIAlertController(title: "写真へのアクセスを許可しますか？",
                                      message: nil,
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "設定画面へ",
                                           style: .default) { (_) in
            guard let settngsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settngsURL,
                                      options: [:],
                                      completionHandler: nil)
        }
        let closeAction = UIAlertAction(title: "キャンセル",
                                        style: .cancel,
                                        handler: nil)
        [settingsAction, closeAction].forEach { alert.addAction($0) }
        present(alert,
                animated: true,
                completion: nil)
    }
    
    private func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController,
                animated: true,
                completion: nil)
    }
    
}
