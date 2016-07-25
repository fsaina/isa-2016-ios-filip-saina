//
//  PokemonDescrptionTableViewCell.swift
//  Pokemaster
//
//  Created by Filip Saina on 25/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

class PokemonDescrptionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
