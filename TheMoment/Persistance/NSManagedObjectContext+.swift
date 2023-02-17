//
//  NSManagedObjectContext++.swift
//  NSManagedObjectContext++
//
//  Created by Yong Jin on 2021/8/14.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {fatalError("Wrong object type")}
        
        return obj
    }
}

extension NSManagedObjectContext {

    /// 在当前上下文根据输入的predicate删除相应的托管对象
    /// - Returns: 其实可以不用返回值，但是因为需要显示定义范性类型，只能提供一个返回值
    func deleteObjects<A: NSManagedObject>(predicate: NSPredicate) ->[A] where A: Managed {
        let request = A.sortedFetchRequest
        request.predicate = predicate
        
        guard let result = try? fetch(request), !result.isEmpty else {return []}
        performChanges {
            result.forEach{
                self.delete($0)
            }
        }
        return result
    }
    
    func fetchOrInsert<A: NSManagedObject>(id: String) -> A where A: Managed {
        
        let request = A.sortedFetchRequest
        request.predicate = A.makeDefaultPredicate(id: id)
        
            guard var result = try? self.fetch(request), !result.isEmpty else {return self.insertObject()}
            
            //移除多余一个以上的实体
            let first = result.removeFirst()
            
                result.forEach{
                    self.delete($0)
                }
            
        return first
    }
    
}


extension NSManagedObjectContext {
    public func saveOrRollback() -> Bool {
        do{
            try self.save()
            return true
        } catch {
            rollback()
            print(#line, #file, #function, "RollBack ", "current context \(self) thread is \(Thread.current.isMainThread ? "main" : "background")" )
            print(error.localizedDescription, "\n")
            return false
        }
    }
    
    public func performChanges(block: @escaping () -> Void) {
        perform{
            block()
            _ = self.saveOrRollback()
        }
    }
}


