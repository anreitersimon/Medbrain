//
//  ConvenienceExtensions.swift
//  Medbrain
//
//  Created by Simon Anreiter on 24/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import Foundation
import SMART

private extension NSDateComponents {
}

extension MedicationDispenseDosageInstruction {
    func dates(from: NSDate, to: NSDate) -> [NSDate] {
        var result = [NSDate]()
        
        timing?.event
        
    }
//
//    if let val = medication.dosageInstruction?.first?.doseQuantity?.value,
//        unit = medication.dosageInstruction?.first?.doseQuantity?.unit,
//        durUnits = medication.dosageInstruction?.first?.timing?.repeat_fhir?.durationUnits,
//        d = medication.dosageInstruction?.first?.timing?.repeat_fhir?.duration {
//            // s | min | h | d | wk | mo
//
//            cell.textLabel?.text = "\(medication.medicationReference?.resolved(Medication)?.description ?? "-" ) :\(val) \(unit), every \(d) \(durUnits)"
//
//            var timeInterval: NSTimeInterval?
//            //
//            // switch units {
//            // case "s":
//            // timeInterval = 1
//            // case "min":
//            // timeInterval = 60
//            // case "h":
//            // timeInterval = 60*60
//            // case "d":
//            // timeInterval = 60*60*24
//            // case "wk":
//            // timeInterval = 60*60*24*7
//            // case "mo":
//            // timeInterval = 60*60*24*7*30
//            // default:
//            // timeInterval = nil
//            // }
//    }
//
//    print("from :\(start) - to: \(end)")
}
