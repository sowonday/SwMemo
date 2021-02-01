//
//  Model.swift
//  SwMemo
//
//  Created by 김소원 on 2021/02/01.
//

import Foundation

class Memo{
    var content: String
    var insertDate: Date
    
    init(content: String){
        self.content = content
        insertDate = Date()
    }
    
    static var dummyMemoList = [
    Memo(content: "Lorem Ipsum"),
    Memo(content: "Subscribe + 👍 = ❤️")
    ]
}
