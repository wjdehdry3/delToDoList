//
//  ViewController.swift
//  TodoListDelete
//
//  Created by 정동교 on 2023/08/31.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!

    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view
        super.viewDidLoad()
        let url = URL(string: "https://api.thecatapi.com/v1/images/search")
        imageView.load(url: url!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        catImageURL()
    }
    
   
    
    func catImageURL() {
        let urlAddress = "https://api.thecatapi.com/v1/images/search"
        if let url = URL(string: urlAddress) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                if let safedata = data {
                    if let image = self.parseJSON(safedata) {
                        DispatchQueue.main.async {
                            self.imageView2.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }

    
    func parseJSON(_ parseData: Data) -> UIImage? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ImageData].self, from: parseData)
            if let firstImage = decodedData.first,
               let imageURL = URL(string: firstImage.url),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                return image
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
  
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
