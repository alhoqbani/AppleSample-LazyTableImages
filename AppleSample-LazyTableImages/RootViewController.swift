//
//  RootViewController.swift
//  AppleSample-LazyTableImages
//
//  Created by Hamoud Alhoqbani on 3/13/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    var entries = [AppRecord]()
    var imageDownloadsInProgress = [IndexPath: IconDownloader]()

    enum cellsIdentifier: String {
        case LazyTableCell
        case PlaceholderCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        terminateAllDownloads()
    }
    
    deinit {
        terminateAllDownloads()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count == 0 ? 1 : entries.count
    }

    //: MARK: TableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell

        // add a placeholder cell while waiting on table data
        if entries.count == 0 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: cellsIdentifier.PlaceholderCell.rawValue, for: indexPath)

        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellsIdentifier.LazyTableCell.rawValue, for: indexPath)

            // Leave cells empty if there's no data yet
            if entries.count > 0 {
                // Set up the cell representing the app
                let appRecord = entries[indexPath.row]
                cell.textLabel?.text = appRecord.appName
                cell.detailTextLabel?.text = appRecord.artist

                // Only load cached images; defer new downloads until scrolling ends
                if (appRecord.appIcon == nil) {

                    if !self.tableView.isDragging && !self.tableView.isDecelerating {
                        startIconDownload(forAppRecord: appRecord, at: indexPath)
                    }
                    
                    // if a download is deferred or in progress, return a placeholder image
                    cell.imageView?.image = #imageLiteral(resourceName:"Placeholder")
                } else {
                    cell.imageView?.image = appRecord.appIcon
                }
            }
        }

        return cell
    }

    //: MARK: Table cell image support
    func startIconDownload(forAppRecord appRecord: AppRecord, at indexPath: IndexPath) {

        // There is a download in progress for the given indexPath
        guard imageDownloadsInProgress[indexPath] == nil else {
            return
        }

        let iconDownloader = IconDownloader(appRecord: appRecord)
        iconDownloader.completionHandler = { [weak self] in
            let cell = self?.tableView.cellForRow(at: indexPath)

            // Display the newly loaded image
            cell?.imageView?.image = appRecord.appIcon

            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            self?.imageDownloadsInProgress.removeValue(forKey: indexPath)
        }

        imageDownloadsInProgress[indexPath] = iconDownloader
        iconDownloader.startDownload()
    }

    // -------------------------------------------------------------------------------
    //    loadImagesForOnscreenRows
    //  This method is used in case the user scrolled into a set of cells that don't
    //  have their app icons yet.
    //  This method will be called by UIScrollViewDelegate
    // -------------------------------------------------------------------------------
    func loadImagesForOnscreenRows() {

        if entries.count > 0, let visiblePaths = tableView.indexPathsForVisibleRows {
            for indexPath in visiblePaths {
                let appRecord = entries[indexPath.row]
                self.startIconDownload(forAppRecord: appRecord, at: indexPath)
            }
        }
    }

    // -------------------------------------------------------------------------------
    //    terminateAllDownloads
    //  Will cancel all pending downloads when the controller is about to leave.
    // -------------------------------------------------------------------------------
    func terminateAllDownloads() {
        imageDownloadsInProgress.forEach { $0.value.cancelDownload() }
        imageDownloadsInProgress.removeAll()
    }

}


//: MARK: UIScrollViewDelegate
extension RootViewController {

    // -------------------------------------------------------------------------------
    //    scrollViewDidEndDragging:willDecelerate:
    //  Load images for all onscreen rows when scrolling is finished.
    // -------------------------------------------------------------------------------
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImagesForOnscreenRows()
        }
    }

    // -------------------------------------------------------------------------------
    //    scrollViewDidEndDecelerating:scrollView
    //  When scrolling stops, proceed to load the images that are on screen.
    // -------------------------------------------------------------------------------
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
}
