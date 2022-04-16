//
//  CommentViewController.swift
//  Instagram
//
//  Created by kurihara on 2022/04/16.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    // 遷移先からくるpostdata格納
    var postDataRecive: PostData?
    // コメント格納用
    var comments: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 投稿ボタンを使えなくする
        postBtn.isEnabled = false
    }

    // テキストフィールド入力時
    @IBAction func handleCommentText(_ sender: Any) {
        if commentText.text == "" {
            postBtn.isEnabled = false
        } else {
            postBtn.isEnabled = true
        }
    }
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // postDataがnilならリターン
        guard let postData = postDataRecive else {
            return
        }
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // 過去分を配列に入れる
        for comment in postData.comments{
            comments.append(comment)
        }
        // 今回追加分
        comments.append(commentText.text!)
        // commentに更新データを書き込む
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        postRef.updateData(["comments": comments])
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        // 前画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        // 前画面に戻る
        self.dismiss(animated: true, completion: nil)
    }


}
