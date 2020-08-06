//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sumit K Agarwal on 8/5/20.
//  Copyright © 2020 Shruti Agarwal. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.rowHeight = 80.0
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        // Configure the cell’s contents.
        cell.textLabel!.text = category.name
        
//        if category.colorHex != nil  {
//            cell.backgroundColor = UIColor(hexString: category.colorHex!)
//        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        //optional binding --> if (tableView.indexPathForSelectedRow) isn't nil then it will execute code body
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //uialert controller
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //add textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        //add action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks Add Item button on our alert
            //append textfield into itemArray
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            //newCategory.colorHex = UIColor(randomFlatColorOf:.light).hexValue()
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        //set up the code to use CD for saving our new items that have been added through uialert
        //save
        do {
            try context.save()
        } catch {
            print ("error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //need to specify the entity you want to request (Item in this case) -- > Parameter
        print("loading items")
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching data from context: \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        let category = self.categoryArray[indexPath.row]
        self.context.delete(category)
        self.categoryArray.remove(at: indexPath.row)

        //self.saveCategories()
        do {
            try self.context.save()
        } catch {
            print ("error saving context \(error)")
        }
    }
    
}



    



