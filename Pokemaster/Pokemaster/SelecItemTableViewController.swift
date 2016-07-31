//
//  SelecItemTableViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 31/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit


class SelecItemTableViewController: UITableViewController {
    
    var itemsList: [SelectableDataHolder]!
    var delegate:AddPokemonViewController!
    var id:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController? .setNavigationBarHidden(false, animated:true)
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.addTarget(self, action: #selector(SelecItemTableViewController.onBackButtonPress), forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Finish", forState: UIControlState.Normal)
        backButton.sizeToFit()
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    func onBackButtonPress(){
        var itemsSelected:[SelectableDataHolder] = []
        
        for i in itemsList{
            if(i.selected == true){
                itemsSelected.append(i)
            }
        }
        
        delegate.didSelectItem(itemsSelected, id: self.id!)
        navigationController!.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.itemsList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectableTableViewCell", forIndexPath: indexPath) as! SelectableItemCell
        
        cell.itemTextlabel.text = itemsList[indexPath.section].text
        
        return cell
    }
    
    //what to do on click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        itemsList[indexPath.section].selected = !itemsList[indexPath.section].selected
        
    }

}



struct SelectableDataHolder{
    
    let text:String
    let idValue:String
    var selected:Bool
    
    init(text:String, idValue:String){
        
        self.text = text
        self.idValue = idValue
        self.selected = false
        
    }

}

class SelectableItemCell: UITableViewCell {
    
    @IBOutlet weak var itemTextlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
