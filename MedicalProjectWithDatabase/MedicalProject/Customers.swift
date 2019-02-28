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
    
    init(custName:String?, custNum:String?, deliv:String?, time:String?,type: String?,country: String?, city: String?, street: String?, equipment: [String: Any]){
        
        self.custName = custName
        self.custNum = custNum
        self.deliv = deliv
        self.time = time
        self.type = type
        self.country = country
        self.city = city
        self.street = street
        self.equipment = equipment
    }
}
