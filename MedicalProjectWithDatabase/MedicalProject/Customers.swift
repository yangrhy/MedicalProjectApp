//
//  Customers.swift
//  MedicalProject
//
//


import Foundation

class Customers{
    
    var custName: String?
    var custNum: String?
    var deliv: String?
    var time: String?
    var type: String?
    var country: String?
    var city: String?
    var street: String?
    var equipment: [String: Any] = [:]
    var location: [String: Any] = [:]
    var returnDate: String?
    
    init(custName:String?, custNum:String?, deliv:String?, time:String?,type: String?, location: [String: Any], equipment: [String: Any]){
        
        self.custName = custName
        self.custNum = custNum
        self.deliv = deliv
        self.time = time
        self.type = type
        self.location = location
        self.equipment = equipment
    }
    
    init(custName:String?, custNum:String?, returnDate:String?, location: [String: Any], equipment: [String: Any]){
        
        self.custName = custName
        self.custNum = custNum
        self.returnDate = returnDate
        self.location = location
        self.equipment = equipment
    }
}
