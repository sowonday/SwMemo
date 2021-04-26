//
//  imageViewController.swift
//  SwMemo
//
//  Created by 김소원 on 2021/03/03.
//

import UIKit

class imageViewController: UIViewController { //이미지 선택
    
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
    }
    func addImage(){
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension imageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
}
