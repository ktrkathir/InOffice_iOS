//
//  TimeSheetDetailViewController.swift
//  InOfffice
//
//  Created by ktrkathir on 03/09/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class TimeSheetDetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet var detailViewModel: TimeSheetDetailViewModel!
    
    var fillColor: UIColor = UIColor.theme
    
    /// Sheet ID
    var sheedID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sheetID = sheedID, !sheetID.isEmpty {
            detailViewModel.fetchDetail(sheedID: sheetID)
        }

        DispatchQueue.main.async {
            self.detailTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constants.Segues.Dashboard.TimeSheetHistory.toNotes {
            let notesVC = segue.destination as! TimesheetNotesViewController
            notesVC.editSheet = sender as? TimeSheetDetails
        }
    }
}

extension TimeSheetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let detail = detailViewModel.details {
            return detail.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: // first cell
            return 80
            
        case ((detailViewModel.details?.count)! - 1): // last cell
            return 80
        default: // middle cell
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: // first cell
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)
            firstCell.tintColor = fillColor.withAlphaComponent(1.0)

            let presentationView = firstCell.contentView.subviews[0]
            presentationView.layer.cornerRadius = 5.0
            presentationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            presentationView.backgroundColor = fillColor
            
            return detailViewModel.updateHistoryDetail(cell: firstCell, indexPath: indexPath)
            
        case ((detailViewModel.details?.count)! - 1): // last cell
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "last", for: indexPath)
            lastCell.tintColor = fillColor.withAlphaComponent(1.0)

            let presentationView = lastCell.contentView.subviews[0]
            presentationView.layer.cornerRadius = 5.0
            presentationView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            presentationView.backgroundColor = fillColor
            
            return detailViewModel.updateHistoryDetail(cell: lastCell, indexPath: indexPath)
            
        default: // middle cell
            let middleCell = tableView.dequeueReusableCell(withIdentifier: "center", for: indexPath)
            middleCell.tintColor = fillColor.withAlphaComponent(1.0)

            middleCell.contentView.subviews[0].backgroundColor = fillColor
            return detailViewModel.updateHistoryDetail(cell: middleCell, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /// Notes button tapped.
        
        UIImpactFeedbackGenerator().impactOccurred()
        
        let detail = detailViewModel.sheetDetail(indexPath: indexPath)
        
        self.performSegue(withIdentifier: Constants.Segues.Dashboard.TimeSheetHistory.toNotes, sender: detail)
    }
}
