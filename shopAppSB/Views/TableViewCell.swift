//
//  TableViewCell.swift
//  shopAppSB
//
//  Created by developer on 5/14/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var productVM: ProductViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(productVM: ProductViewModel) {
        self.productVM = productVM
        self.updateCell()
        productVM.loadImageData()
    }
    override func prepareForReuse() {
        self.productVM = nil
    }
    
    func affixModelToCell() {
        
        guard let name = self.productVM?.name, let price = self.productVM?.price else {
                print("data problem")
                return
        }
        if self.productVM?.isForItem != true {
            self.nameLabel.text = name
            self.priceLabel.text = price
        }else {
            guard let imageData = self.productVM?.imageData, let cellImage = UIImage(data: imageData) else {
                    print("image problem")
                    return
            }
            
            self.nameLabel.text = name
            self.priceLabel.text = price
            self.cellImage.image = cellImage
        }
    }
    
    func updateCell() {
        DispatchQueue.main.async {
            self.affixModelToCell()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
