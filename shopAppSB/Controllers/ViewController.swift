//
//  ViewController.swift
//  shopAppSB
//
//  Created by developer on 5/12/22.
//

import UIKit

class ViewController: UIViewController {
    var vm = ShopViewModel()
    
    
    @IBOutlet weak var cartIcon: UIBarButtonItem!
    
    
    @IBOutlet weak var browseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browseTable.dataSource = self
        browseTable.delegate = self
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        browseTable.register(nib, forCellReuseIdentifier: "Item")
        
        setupdateIconFunction()
        
        vm.updateProductsDisplay = {
            DispatchQueue.main.async {
                self.browseTable.reloadData()
            }
        }
        getData()
    }

    func setupdateIconFunction() {
        self.vm.cart.updateCartIcon = {
            if self.vm.cart.isCartEmpty != true {
                self.vm.cart.cartIconString = "cart.fill"
            }else {
                self.vm.cart.cartIconString = "cart"
            }
                
            DispatchQueue.main.async {
                self.cartIcon.image = UIImage(systemName: self.vm.cart.cartIconString)
            }
        }
    }

    func getData() {
        vm.loadProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CartSegue" {
            let destination = segue.destination as? CartViewController
            guard let destination = destination else {
                print("couldn't get cartviewcontroller")
                return
            }
            destination.vm = self.vm.cart
            
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = browseTable.dequeueReusableCell(withIdentifier: "Item") as? TableViewCell else {
            return UITableViewCell()
        }
        
        guard let productVM = self.vm.products?[indexPath.row] else {
            print("no productVM found in vm")
            return UITableViewCell()
        }
        productVM.rowNumber = indexPath.row
        cell.configure(productVM: productVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = browseTable.indexPathForSelectedRow
        else {
            print("couldn't find index path of selected row")
            return
        }
        
        let chosenCell = browseTable.cellForRow(at: index) as? TableViewCell
        
        guard let chosenVM = chosenCell?.productVM else {
            print("cell didn't have a vm attached")
            return
        }
        
        
        let confirmation = UIAlertController(title: "\(chosenVM.name ?? "")", message: "please confirm choice", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                style: .cancel) { action in
           }
        
        let addToCartAction = UIAlertAction(title: "Add to cart", style: .default, handler: {
            _ in
            self.vm.cart.addToCart(productVM: chosenVM)
        })
        
        confirmation.addAction(cancelAction)
        confirmation.addAction(addToCartAction)
        
        self.present(confirmation, animated: true)
    }
}
