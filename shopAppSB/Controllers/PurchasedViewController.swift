//
//  PurchasedViewController.swift
//  shopAppSB
//
//  Created by developer on 5/15/22.
//

import UIKit

class PurchasedViewController: UIViewController {
    
    var vm: [ProductViewModel]?

    @IBOutlet weak var purchasedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        purchasedTableView.dataSource = self
        purchasedTableView.delegate = self
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        purchasedTableView.register(nib, forCellReuseIdentifier: "Item")
    }
}

extension PurchasedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = purchasedTableView.dequeueReusableCell(withIdentifier: "Item") as? TableViewCell else {
            return UITableViewCell()
        }
        guard let purchasedItems = self.vm else {
            print("unable to set vm")
            return UITableViewCell()
        }
        
        let productVM = purchasedItems[indexPath.row]
        productVM.rowNumber = indexPath.row
        cell.configure(productVM: productVM)
        return cell
    }
}

