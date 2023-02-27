//
//  NSManagedObjectContext++.swift
//  NSManagedObjectContext++
//
//  Created by Yong Jin on 2021/8/14.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A {
        let obj = A(context: self)
        return obj
    }
    
}

extension NSManagedObjectContext {
    /// 在当前上下文根据输入的predicate删除相应的托管对象
    /// - Returns: 其实可以不用返回值，但是因为需要显示定义范性类型，只能提供一个返回值
    func deleteObjects<A: NSManagedObject>(predicate: NSPredicate) -> [A] {
        let request = A.sortedFetchRequest
        request.predicate = predicate
        
        guard let result = try? fetch(request) as? [A], !result.isEmpty else { return [] }
        performChanges {
            result.forEach {
                self.delete($0)
            }
        }
        return result
    }
    
    // TODO:
    func fetch<A: NSManagedObject>(predicate: NSPredicate) -> A? {
        let request = A.sortedFetchRequest
        request.predicate = predicate
        
        guard var result = try? self.fetch(request), !result.isEmpty else { return nil }
            
        // 移除多余一个以上的实体
        let first = result.removeFirst()
            result.forEach {
                self.delete($0)
            }
             
        return result.first as? A
    }
}

public extension NSManagedObjectContext {
    func saveOrRollback() -> Bool {
        do {
            try self.save()
            return true
        } catch {
            rollback()
            print(#line, #file, #function, "RollBack ", "current context \(self) thread is \(Thread.current.isMainThread ? "main" : "background")")
            print(error.localizedDescription, "\n")
            return false
        }
    }
    
    func performChanges(block: @escaping () -> Void) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
    
    func doAsyncAction() {
        perform {
            print("hello")
        }
    }
}
