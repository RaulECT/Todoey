//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Raul  Canul on 10/8/18.
//  Copyright © 2018 Raul  Canul. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        cell.backgroundColor = UIColor(hexString: (categoryArray?[indexPath.row].color)!)
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (categoryArray?[indexPath.row].color)!)!, returnFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // MARK: - TableView Delegate Methods


    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            //self.categoryArray.append(newCategory)
            self.save( category: newCategory )
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present( alert, animated: true, completion: nil )
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do{
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
    }
    
    func save( category: Category ) {
        do {
            //try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting categories, \(error)")
            }
        }
    }
    
}

//// MARK: - Swipe Cell delegate methods
//
//extension CategoryTableViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            // handle action by updating model with deletion
//            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                }catch {
//                    print("Error deleting category \(error)")
//                }
//
//                //tableView.reloadData()
//            }
//
//        }
//
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeTableOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//
//        return options
//    }
//
//
//}
