//
//  ViewController.swift
//  shopAppSB
//
//  Created by developer on 5/12/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.browseTable.reloadData()
            }
        }
    }

    @IBOutlet weak var browseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browseTable.dataSource = self
        browseTable.delegate = self
        browseTable.register(UITableViewCell.self, forCellReuseIdentifier: "Item")
        getData()
    }

    func getData() {
        Webservice().getItems(completion: { items in
            self.items = items
            print(items)
        })
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = browseTable.dequeueReusableCell(withIdentifier: "Item") else {
            return UITableViewCell()
        }
        let name = items[indexPath.row].name
        cell.textLabel?.text = name
        return cell
    }
}
