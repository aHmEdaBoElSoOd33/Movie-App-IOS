//
//  ReviewsVC1.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 10/12/2022.
//

import UIKit

class ReviewsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var reviewArray : [Review] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReviewsCell

        cell.autherName.text = reviewArray[indexPath.row].name
        cell.autherContent.text = reviewArray[indexPath.row].content

        return cell
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
}
