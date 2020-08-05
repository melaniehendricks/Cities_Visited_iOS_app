//
//  ViewController.swift
//  Lab5
//
//  Created by Melanie Hendricks on 3/20/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    
    // declare variables
    let selectedPhoto  = UIImageView()
    var cityName:String = ""
    var cityDesc:String = ""
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    var pickerView = UIPickerView()
    var toDelete:City?
    var typeValue:String?
    
    
    // getting a handler to the CoreData managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var m:Model?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m = Model(context: managedObjectContext)
        updateView()
    }
    
    
    private func updateView(){
        let hasCities = m!.getCount() > 0
        cityTable.isHidden = !hasCities
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView methods
    
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let c = m?.getCount()
        return c!
    }
    
    // get city for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CityTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        cell.layer.borderWidth = 0.9
        
        // fetch city
        let cityItem = m?.getCityObject(index: indexPath.row)
        cell.cityTitle.text = cityItem?.name
                
        if cityItem?.picture != nil{
            // saved as Data in Coredata
            // need to convert from Data to UIImage
            let imageData: UIImage = UIImage(data: cityItem!.picture!)!
            cell.cityImage.image = imageData
            cell.cityImage.isHidden = false
        }else{
            cell.cityImage.image = #imageLiteral(resourceName: "placeholder")
            print(cityItem.self)
     }
        
        

        return cell
    }
    
    // make cells bigger
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.cityTable.reloadRows(at: [indexPath], with: .fade)
    }
    
    

    // MARK: - Delete PickerView methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let count = self.m?.getCount()
        return count!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let city = self.m?.getCityObject(index: row)
        let title = city?.name
        return title
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set typeValue to name of city
        let city = self.m?.getCityObject(index: row)
        typeValue = city?.name
    }
    
    
    // MARK: - Add and Delete buttons
    
    // add new city (name + description)
    @IBAction func add(_ sender: Any) {
        
        
        // UIAlertController with 2 text fields (name, description)
        
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        
        
        // CANCEL
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            action in
            
            let firstField = alert.textFields![0] as UITextField
                let secondField = alert.textFields![1] as UITextField
                
                if let x = firstField.text, let y = secondField.text{
                    print(firstField.text)
                    print(secondField.text)
            
                    self.cityName = x
                    self.cityDesc = y
                    
                }
        }
        
        // TEXT FIELDS
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter the name of the city here"})
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter the city's description here"})
        
        
        // CAMERA
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            action in
            
            // check if there is a camera available for application
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.cityName = alert.textFields!.first!.text!
                self.cityDesc = alert.textFields!.last!.text!
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                
                // source is camera
                picker.sourceType = UIImagePickerController.SourceType.camera
                
                // photo mode (vs. video mode)
                picker.cameraCaptureMode = .photo
                
                // can view full image
                picker.modalPresentationStyle = .fullScreen
                
                // load camera view
                self.present(picker, animated: true, completion: nil)
                
            }else{
                print("No camera")
            }
        }
        
        // PHOTO LIBRARY
        let libAction = UIAlertAction(title: "Photo Library", style: .default){
            action in
            self.cityName = alert.textFields!.first!.text!
            self.cityDesc = alert.textFields!.last!.text!
            let picker = UIImagePickerController()
            picker.delegate = self
            // photo library is selected
            picker.allowsEditing = false
            
            // source is photo library
            picker.sourceType = .photoLibrary
            
            // load available photo library UI
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            // style
            picker.modalPresentationStyle = .popover
            
            // load photo library
            self.present(picker, animated: true, completion: nil)
            
            
        }
        
        // add actions to Alert Controller object
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(libAction)
        
    
        // make visible
        self.present(alert, animated: true)
    }
    
    
    // delete city
    @IBAction func remove(_ sender: Any) {
                
        // UIAlertController with 1 text field (name)
        let alert = UIAlertController(title: "Delete City", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPresentation = true
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        // delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .default){
            action in
            
            var count = self.m?.getCount()
            print(count)
            self.m?.deleteCity(name: self.typeValue!)
            self.cityTable.reloadData()
            print(count)
              
        }
        
        // delete all action
        let deleteAll = UIAlertAction(title: "Delete All", style: .default){
            action in
            self.m?.deleteAll()
            let count = self.m?.getCount()
            self.cityTable.reloadData()
            print(count)
        }
        
        // add actions to Alert Controller object
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(deleteAll)
        
        // make visible
        self.present(alert, animated: true)
        
    }
    
    
     // MARK: - Image Picker Controller Delegates + Helper functions
    
    // load info about image into info object
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // dismiss view that shows camera or photo library
        picker.dismiss(animated: true, completion: nil)
        
        // create image object based on picture taken or photo selected
        selectedPhoto.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        
        // call addCity function in Model
        self.m?.addCity(name: cityName, desc: cityDesc, photo: self.selectedPhoto.image!.jpegData(compressionQuality: 0.9)!)

        let count = self.m?.getCount()
        let count2:Int? = count! - 1
        
        let indexPath = IndexPath(row: count2!, section: 0)
        self.cityTable.beginUpdates()
        self.cityTable.insertRows(at: [indexPath], with: .automatic)
        self.cityTable.endUpdates()
        
        self.updateView()
        
        print(count)
                
    }

    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String:Any]{
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String{
        return input.rawValue
    }
   
    
    
    // segue to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let selectedIndex :IndexPath = self.cityTable.indexPath(for: sender as! UITableViewCell)!
        
        let city = m?.getCityObject(index: selectedIndex.row)
        
        // if segue idenifier is "toDetailView"
        // pass selected city to DetailViewController
        if segue.identifier == "toDetailView"{
            if let viewController:DetailViewController = segue.destination as? DetailViewController{
                viewController.name = city!.name
                viewController.desc = city!.desc
                viewController.image = city!.picture
                
                
            }
        }
    }
}

