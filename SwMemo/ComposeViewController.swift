//
//  ComposeViewController.swift
//  SwMemo
//
//  Created by 김소원 on 2021/02/01.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    @IBAction func addimage(_ sender: Any) {// 새 메모에서 이미지 선택

        let alert = UIAlertController(title: "사진", message: "사진을 선택해주세요.", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "사진앨범", style: .default) { [weak self] (action) in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "삭제", style: .default, handler: nil)

        alert.addAction(action)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)



    }
    
    @IBOutlet weak var newimage: UIImageView!
    
    
    
    @IBAction func save(_
                            sender: Any) {
        
        guard let memo = memoTextView.text,
              memo.count > 0 else{
            alert(message: "메모를 입력하세요")
            return
        }
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget{
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else{
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)

        }
        
        
        
        dismiss(animated: true, completion: nil)

    
    }
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken{
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    

    override func viewDidLoad() {
            super.viewDidLoad()

            if let memo = editTarget{
                navigationItem.title = "메모편집"
                memoTextView.text = memo.content
                originalMemoContent = memo.content
            }else{
                navigationItem.title = "새 메모"
                memoTextView.text = ""
            }
        
        memoTextView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
                NSValue{
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else {return}
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
            
        })
                                                    
                                                               
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.becomeFirstResponder()
        navigationController?.presentationController?.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memoTextView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
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

extension ComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text{
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집할 내용을 저장할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) {[weak
            self] (action) in
            self?.save(action)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {[weak self] (action) in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
