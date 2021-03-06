//
//  BlogFeedCell_Table.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class BlogFeedCell_Table: BlogFeedCell,BlogFeedTableViewBindProtocol {
    
    var cellNibSet = [FeedCellStyle.tableCell.cellIdentifier]
    var selectedCell = PublishSubject<(IndexPath, BlogFeedCellViewModel)>()
    var reloaded = PublishSubject<Void>()
    var insideCellEvent = PublishSubject<Any>()
    
    @IBOutlet var tableView: UITableView!
    typealias ModelType = BlogFeedCellViewModel
    var cellViewModels = Variable<[AnimatableSectionModel<String, BlogFeedCellViewModel>]>([])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: 1))
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.bindDataSource(tableView: self.tableView)
        self.selectedCell.subscribe(onNext: { [weak self] (indexPath,viewModel) in
            if case .tableCell = viewModel.style, let entryViewModel = viewModel.entryViewModels.first {
                self?.insideEvent?.on(.next(entryViewModel))
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate
extension BlogFeedCell_Table: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 4
    }
}
