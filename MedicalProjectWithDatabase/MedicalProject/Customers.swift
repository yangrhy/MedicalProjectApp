//
//  Customers.swift
//  
//
//  Created by Ricky Yang on 2/9/19.
//

import Foundation

class Customers{
    
    var custName: String?
    var custAddy: String?
    var custNum: String?
    var deliv: String?
    var time: String?
    var type: String?
    
    var bed: String?
    var bloodGlucose: String?
    var iVSolution: String?
    var infusion: String?
    var nebulizer: String?
    var pulseOx: String?
    var syringe: String?
    var thermometer: String?
    var walker: String?
    
    init(custName:String?, custAddy:String?, custNum:String?, deliv:String?, time:String?,type: String?, bed: String?, bloodGlucose: String?,iVSolution: String?, infusion: String?, nebulizer: String?, pulseOx: String?, syringe: String?, thermometer: String?,
        walker: String? ){
        
        self.custName = custName
        self.custAddy = custAddy
        self.custNum = custNum
        self.deliv = deliv
        self.time = time
        self.type = type
        
        self.bed = bed
        self.bloodGlucose = bloodGlucose
        self.iVSolution = iVSolution
        self.infusion = infusion
        self.nebulizer = nebulizer
        self.pulseOx = pulseOx
        self.syringe = syringe
        self.thermometer = thermometer
        self.walker = walker
    }
}
