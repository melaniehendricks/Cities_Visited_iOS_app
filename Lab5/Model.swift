//
//  Model.swift
//  Lab5
//
//  Created by Melanie Hendricks on 3/20/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import Foundation
import CoreData
class Model{
    // create 
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext){
        
        // getting a handler to the CoreData managed object context
        managedObjectContext = context
    }
    
    // add city
    func addCity(name:String, desc:String, photo:Data){
        
        // get ahandler to the City entity through the managed object context
        let ent = NSEntityDescription.entity(forEntityName: "City", in: self.managedObjectContext!)
        
        // create a City object instance to add
        let city = City(entity: ent!, insertInto: managedObjectContext)
        
        // add data to each field in entity
        city.name = name
        city.desc = desc
        city.picture = photo
        
        // save new entity
        do{
            try managedObjectContext!.save()
            print("City saved")
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    
    // fetch city and delete it
    func deleteCity(name:String) -> Int{
        let city = name
        let match: NSManagedObject = query(name: city)
        managedObjectContext?.delete(match)
        return 0
        
    }
    
    
    func query(name:String) -> NSManagedObject{
        // search for correct object
          var match: NSManagedObject?
        
        // get handler to the City entity
        let ent = NSEntityDescription.entity(forEntityName: "City", in: managedObjectContext!)
        
        // create fetch request
        let request:NSFetchRequest<City> = City.fetchRequest() as! NSFetchRequest<City>
        
        // associate the request wtih city handler
        request.entity = ent
        
        // build search request predicate (query)
        let pred = NSPredicate(format: "(name == %@)", name)
        request.predicate = pred
        
        // perform the query and process the query results
        do{
            var results = try managedObjectContext!.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            
            if results.count > 0{
                match = results[0] as! NSManagedObject
            }else{}
        } catch let error{
            print(error.localizedDescription)
        }
        return match!
    }
    
    // fetch all objects
    func fetch() -> [City]{
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        var records:[City] = []
        do{
            records = try managedObjectContext!.fetch(fetchRequest)
        }catch{
            print(error)
        }
        return records
    }
    
    // get city object
    func getCityObject(index:Int) -> City{
        var cities = fetch()
        let target = cities[index]
        return target
    }
    
    // delete all cities
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        // performs batch delete
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try managedObjectContext!.execute(deleteRequest)
            try managedObjectContext!.save()
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
    // get City count
    func getCount() -> Int{
        var iCount:Int? = -1
        // create fetch request
        let cityFetchRequest = NSFetchRequest<NSNumber>(entityName: "City")
        
        // define result type
        cityFetchRequest.resultType = .countResultType
        
        do{
            // execute fetch request
            let counts: [NSNumber]! = try managedObjectContext?.fetch(cityFetchRequest)
            for count in counts{
                iCount = (count != nil) ? Int(count) : nil
                return iCount!
            }
        }
        catch let error as NSError{
            print("Could not fetch \(error)")
        }
     return iCount!
    }
    
}
