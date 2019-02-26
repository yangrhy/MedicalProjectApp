//
//  EquipmentViewController.swift
//  MedicalProject
//
//  Created by Ashley on 2/20/19.
//

import UIKit

class EquipmentViewController: UIViewController {

    
    

    @IBOutlet weak var ThermometerStepper: UIStepper!
    
    @IBOutlet weak var SyringeStepper: UIStepper!
    
    @IBOutlet weak var NebuilzerStepper: UIStepper!
    
    @IBOutlet weak var BloodGlucoseStepper: UIStepper!
    
    @IBOutlet weak var WalkerStepper: UIStepper!
    
    @IBOutlet weak var InfusionStepper: UIStepper!
    
    @IBOutlet weak var IvSolutionStepper: UIStepper!
    
    @IBOutlet weak var BedStepper: UIStepper!

    @IBOutlet weak var PulseOxStepper: UIStepper!
    
    
    @IBAction func ThermometerStepChange(_ sender: UIStepper) {
        ThermometerLabel.text = Int(sender.value).description
    }
    
    @IBAction func SyringeStepChange(_ sender: UIStepper) {
        SyringeLabel.text = Int(sender.value).description
    }
    
    @IBAction func NebulizerStepChange(_ sender: UIStepper) {
        NebuilzerLabel.text = Int(sender.value).description
    }
    
    @IBAction func BloodGlucoseStepChange(_ sender: UIStepper) {
        BloodGlucoseLabel.text = Int(sender.value).description
    }
    
    @IBAction func WalkerStepChange(_ sender: UIStepper) {
        WalkerLabel.text = Int(sender.value).description
    }
    
    @IBAction func InfusionStepChange(_ sender: UIStepper) {
        InfusionLabel.text = Int(sender.value).description
    }
    
    @IBAction func IvSolutionStepChange(_ sender: UIStepper) {
        IvSolutionLabel.text = Int(sender.value).description
    }
    
    @IBAction func BedStepChange(_ sender: UIStepper) {
        BedLabel.text = Int(sender.value).description
    }
    
    @IBAction func PulseOxStepChange(_ sender: UIStepper) {
        PulseOximeterLabel.text = Int(sender.value).description
    }
    
    
    @IBOutlet weak var ThermometerLabel: UILabel!
    
    @IBOutlet weak var SyringeLabel: UILabel!
    
    @IBOutlet weak var NebuilzerLabel: UILabel!
    
    @IBOutlet weak var PulseOximeterLabel: UILabel!
    
    @IBOutlet weak var BloodGlucoseLabel: UILabel!
    
    @IBOutlet weak var WalkerLabel: UILabel!
    
    @IBOutlet weak var InfusionLabel: UILabel!
    
    @IBOutlet weak var IvSolutionLabel: UILabel!
    
    @IBOutlet weak var BedLabel: UILabel!
    
    
    
    @IBAction func SubmitButton(_ sender: AnyObject) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! DataViewController
        myVC.ThermometerPassed = ThermometerLabel.text!
        myVC.SyringePassed = SyringeLabel.text!
        myVC.NebuilzerPassed = NebuilzerLabel.text!
        myVC.PulseOximeterPassed = PulseOximeterLabel.text!
        myVC.BloodGlucosePassed = BloodGlucoseLabel.text!
        myVC.WalkerPassed = WalkerLabel.text!
        myVC.InfusionPassed = InfusionLabel.text!
        myVC.IvSolutionPassed = IvSolutionLabel.text!
        myVC.BedPassed = BedLabel.text!
        navigationController?.pushViewController(myVC, animated: true)
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ThermometerStepper.wraps = true
        ThermometerStepper.autorepeat = true
        ThermometerStepper.maximumValue = 10
        
        SyringeStepper.wraps = true
        SyringeStepper.autorepeat = true
        SyringeStepper.maximumValue = 10
        
        NebuilzerStepper.wraps = true
        NebuilzerStepper.autorepeat = true
        NebuilzerStepper.maximumValue = 10
        
        PulseOxStepper.wraps = true
        PulseOxStepper.autorepeat = true
        PulseOxStepper.maximumValue = 10
        
        BloodGlucoseStepper.wraps = true
        BloodGlucoseStepper.autorepeat = true
        BloodGlucoseStepper.maximumValue = 10
        
        WalkerStepper.wraps = true
        WalkerStepper.autorepeat = true
        WalkerStepper.maximumValue = 10
        
        InfusionStepper.wraps = true
        InfusionStepper.autorepeat = true
        InfusionStepper.maximumValue = 10
        
        IvSolutionStepper.wraps = true
        IvSolutionStepper.autorepeat = true
        IvSolutionStepper.maximumValue = 10
        
        BedStepper.wraps = true
        BedStepper.autorepeat = true
        BedStepper.maximumValue = 10
        
        
    }
    


}
