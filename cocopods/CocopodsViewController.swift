//
//  CocopodsViewController.swift
//  cocopods
//
//  Created by ying kit ng on 4/3/21.
//

import UIKit
import SwiftUI
import SideMenu
import Alamofire

class CocopodsViewController: UIViewController {

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AF.request("https://httpbin.org/get").response { response in
//            debugPrint(response)
//        }
       
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

struct CocopodsViewControllerRepresentation: UIViewControllerRepresentable{
    
//    func makeCoordinator() -> () {
//        Coordinator(self)
//    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CocopodsViewControllerRepresentation>) -> CocopodsViewController{
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CocopodsViewController") as! CocopodsViewController
//
//        fireViewC = context.coordinator
//
//        return fireViewC
    }
    
    func updateUIViewController(_ uiViewController: CocopodsViewController, context: UIViewControllerRepresentableContext<CocopodsViewControllerRepresentation>) {
        
    }
    
}
