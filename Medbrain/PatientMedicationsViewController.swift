//
//  PatientMedicationsViewController.swift
//  Medbrain
//
//  Created by Simon Anreiter on 10/04/16.
//  Copyright © 2016 anreiter.simon. All rights reserved.
//

import UIKit
import Operations
import SMART

enum LoadingState {
    case Initial, LoadingContent, Error, ContentLoaded, NoContent, Refreshing
}

extension LoadingState {
    var message: String? {
        switch self {
        case .Initial:
            return nil
        case .LoadingContent:
            return nil
        case .Error:
            return "Fehler"
        case .ContentLoaded:
            return nil
        case .NoContent:
            return "Keine Ergebnisse gefunden"
        case .Refreshing:
            return nil
        }
    }

    var needsLoadingIndicator: Bool {
        return self == .LoadingContent
    }
}

class PatientMedicationsViewController: UITableViewController {
    lazy var queue = OperationQueue()

    var medications: [MedicationOrder]?

    var label: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    var container: UIView!

    func refresh(sender: AnyObject?) {
        self.loadContent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)

        navigationItem.title = "Medikationen"

        container = UIView(frame: CGRect.zero)

        label = UILabel(frame: CGRect.zero)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.lightGrayColor()
        activityIndicator.hidesWhenStopped = true

        container.addSubview(label)
        container.addSubview(activityIndicator)

        label.leadingAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.leadingAnchor).active = true
        label.topAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.topAnchor).active = true

        container.layoutMarginsGuide.trailingAnchor.constraintEqualToAnchor(label.trailingAnchor).active = true
        container.layoutMarginsGuide.bottomAnchor.constraintEqualToAnchor(label.bottomAnchor).active = true

        activityIndicator.centerXAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.centerXAnchor).active = true
        activityIndicator.centerYAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.centerYAnchor).active = true
    }

    func configureForState(state: LoadingState) {
        let tuple = (state.needsLoadingIndicator, state.message)

        if state == .Refreshing {
            return
        }

        switch tuple {
        case (true, _):
            tableView.backgroundView = container
            tableView.separatorStyle = .None
            activityIndicator.startAnimating()
            label.hidden = true
        case (false, .Some(let message)):
            tableView.backgroundView = container
            tableView.separatorStyle = .None
            activityIndicator.stopAnimating()
            label.text = message
            label.hidden = false

        default:
            tableView.backgroundView = nil
            activityIndicator.stopAnimating()
            tableView.separatorStyle = .SingleLine
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redColor()
        tabBarController?.view.tintColor = UIColor.redColor()
    }

    var state = LoadingState.Initial {
        didSet {
            configureForState(state)
            tableView.reloadData()
        }
    }

    func loadContent() {
        switch state {
        case .LoadingContent, .Refreshing:
            return
        case .Initial:
            state = .LoadingContent
        default:
            state = .Refreshing
        }

        let op = BlockOperation {
            guard let id = SignInController.sharedSignInController.patient?.id else {
                return
            }
            MedicationOrder.search(["patient": id]).perform(SignInController.sharedSignInController.server) { [weak self](bundle, error) in

                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    self?.state = .Error
                    return
                }

                let meds = bundle?.entry?
                    .filter() { return $0.resource is MedicationOrder }
                    .map() { return $0.resource as! MedicationOrder } ?? []

                dispatch_async(dispatch_get_main_queue()) {
                    strongSelf.refreshControl?.endRefreshing()
                    strongSelf.state = meds.isEmpty ? .NoContent : .ContentLoaded

                    strongSelf.medications = meds
                    strongSelf.tableView.reloadData()
                }
            }
        }

        op.addCondition(SignedInCondition(presentationContext: self))

        queue.addOperation(op)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        loadContent()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.cell)!

        let medication = medications![indexPath.row]

        let boundsPeriod = medication.dosageInstruction?.first?.timing?.repeat_fhir?.boundsPeriod

        let start = boundsPeriod?.start?.nsDate, end = boundsPeriod?.end?.nsDate

        cell.textLabel?.text = medicationName(medication)
        cell.detailTextLabel?.text = nil
        cell.textLabel?.numberOfLines = 0

        if let val = medication.dosageInstruction?.first?.doseQuantity?.value,
            unit = medication.dosageInstruction?.first?.doseQuantity?.unit,
            durUnits = medication.dosageInstruction?.first?.timing?.repeat_fhir?.durationUnits,
            d = medication.dosageInstruction?.first?.timing?.repeat_fhir?.duration {
                // s | min | h | d | wk | mo

                cell.textLabel?.text = "\(medication.medicationReference?.resolved(Medication)?.description ?? "-" ) :\(val) \(unit), every \(d) \(durUnits)"

                var timeInterval: NSTimeInterval?
//
//            switch units {
//            case "s":
//                timeInterval = 1
//            case "min":
//                timeInterval = 60
//            case "h":
//                timeInterval = 60*60
//            case "d":
//                timeInterval = 60*60*24
//            case "wk":
//                timeInterval = 60*60*24*7
//            case "mo":
//                timeInterval = 60*60*24*7*30
//            default:
//                timeInterval = nil
//            }
        }

        print("from :\(start) - to: \(end)")

        return cell
    }

    func medicationName(med: MedicationOrder) -> String {
        if let medname = med.medicationCodeableConcept?.coding?.first?.display {
            return medname
        }

        if let html = med.text?.div {
            do {
                let stripTags = try NSRegularExpression(pattern: "(<[^>]+>\\s*)|(\\r?\\n)", options: .CaseInsensitive)
                return stripTags.stringByReplacingMatchesInString(html, options: [], range: NSMakeRange(0, html.characters.count), withTemplate: "")
            } catch { }
        }
        if let display = med.medicationReference?.display {
            return display
        }
        return "No medication and no narrative"
    }
}
