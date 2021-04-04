//
//  NetworkViewController.swift
//  Practice using file management
//  Write file into the Application Support folder
//
//  Created by ying kit ng on 4/4/21.
//

import UIKit

class NetworkViewController: UIViewController {

    @IBAction func openFile(_ sender: Any) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsurl)
            print(docsurl.path)
            
            // create stock file in the mobile system.
            let stock = Stock(name: "AAA", value: "100")
            let stockdata = try NSKeyedArchiver.archivedData(withRootObject: stock, requiringSecureCoding: true)
            let stockfile = docsurl.appendingPathComponent("stock.txt")
            
            //try stockdata.write(to: stockfile, options: .atomic)
            
            //to find content of the folder
            let arr = try fm.contentsOfDirectory(at:docsurl, includingPropertiesForKeys: nil)
            arr.forEach{ print($0.lastPathComponent) }
            
            //retrieve the saved file
            let personaldata = try Data(contentsOf: stockfile)
            let storedStock = try NSKeyedUnarchiver.unarchivedObject(ofClass: Stock.self, from: personaldata)!
            print(storedStock)
            
            
            
        } catch {
            //deal with the error here
        }
    }
    
    
    @IBAction func writeperson(_ sender: Any) {
        
        //writeCodable()
        
       // getfilewithCoordinator()
       // retrieveWithCoordinator()
       //  filewrapperWrite()
        filewrapperRead()
    }
    
    //write person Codable object
    private func writeCodable(){
                do{
                    let fm = FileManager.default
                    let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let moi = Person(firstName: "Ken", lastName: "Eng")
                    let moidata = try PropertyListEncoder().encode(moi)
                    let moifile = docsurl.appendingPathComponent("moi.txt")
                    try moidata.write(to: moifile, options: .atomic)
        
                    // retrieve the Codable object
                    let personaldata = try Data(contentsOf: moifile)
                    let person = try PropertyListDecoder().decode(Person.self, from: personaldata)
                    print(person)
                } catch {
        
                }
    }
    
    // NSFileCoordinator along with NSFileAccessIntent is good for reading or writing to which you have handed the URL of your target file
    private func getfilewithCoordinator(){
        do{
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            let moi = Person(firstName: "Ken", lastName: "Eng")
            let moidata = try PropertyListEncoder().encode(moi)
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.writingIntent(with: moifile)
            fc.coordinate(with: [intent], queue: .main ) { err in
                do {
                    try moidata.write(to: intent.url, options: .atomic)
                } catch {
                    print(error)
                }
            }
        } catch{
            
        }
    }
    
    private func retrieveWithCoordinator(){
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            let moi = Person(firstName: "Ken", lastName: "Eng")
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.writingIntent(with: moifile)
            fc.coordinate(with: [intent], queue: .main ) { err in
                do {
                    let persondata = try Data(contentsOf: intent.url)
                    let person = try PropertyListDecoder().decode(Person.self, from: persondata)
                    print(person)
                } catch {
                    print(error)
                }
            }
        } catch {
            
        }
    }
    
    // for image use File Wrappers
    
    private func filewrapperWrite() {
        let fm = FileManager.default
        let d = FileWrapper(directoryWithFileWrappers: [:])
        let docurl = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let imnames = ["jack.jpg"]
        for imname in imnames {
            d.addRegularFile(
                withContents:
                    UIImage(named: imname)!.jpegData(compressionQuality: 1)! ,
                preferredFilename: imname)
        }
        do {
            let list = try! PropertyListEncoder().encode(imnames)
            d.addRegularFile(withContents: list, preferredFilename: "list")
            let fwurl = docurl.appendingPathComponent("cocopods")
            try d.write(to: fwurl, originalContentsURL: nil)
        } catch {
            
        }
    }
    
    private func filewrapperRead(){
        let fm = FileManager.default
        let docurl = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fwurl = docurl.appendingPathComponent("cocopods")
        do {
            let d = try FileWrapper(url: fwurl)
            if let list = d.fileWrappers?["list"]?.regularFileContents {
                let imnames = try PropertyListDecoder().decode([String].self, from: list)
                print("got", imnames)
                for imname in imnames {
                    if let imdata = d.fileWrappers?[imname]?.regularFileContents {
                        print("got image data for", imname)
                        // in real life, do something with the image here
                        _ = imdata
                    }
                }
            } else {
                print("no list")
            }
        } catch {
            print(error); return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

class Stock: NSObject , NSSecureCoding {
    func encode(with coder: NSCoder) {
        //do not call super in this case
        coder.encode(self.name, forKey: "name")
        coder.encode(self.value, forKey: "value")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(of: NSString.self, forKey: "name")! as String
        self.value = coder.decodeObject(of: NSString.self, forKey: "value")! as String
    }
    
    static var supportsSecureCoding: Bool {return true}
    
    var name: String
    var value: String
    
    override var description: String {
        return self.name + " " + self.value
    }
    
    init(name: String, value: String){
        self.name = name
        self.value = value
        super.init()
    }
}


// object that confirms to Codable , properties are Strings and String is itself Codable
class Person: NSObject, Codable {
    var firstName : String
    var lastName : String
    
    override var description : String {
        return self.firstName + " " + self.lastName
    }
    
    init(firstName:String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }
}
