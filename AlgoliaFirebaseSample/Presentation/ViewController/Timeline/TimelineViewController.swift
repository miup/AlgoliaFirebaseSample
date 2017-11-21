//
//  TimelineViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimelineViewController: ViewController {

    private let useCase = TimelineUseCase()
    private let dataSource = TimelineDataSource()
    private let disposeBag = DisposeBag()


    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .plain)
        view.rowHeight = UITableViewAutomaticDimension
        view.registerNib(type: FeedCell.self)
        view.tableFooterView = UIView()
        return view
    }()

    let refreshControl = UIRefreshControl()

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "タイムライン"
        bind()
        tableView.refreshControl = refreshControl
        useCase.fetch()
    }

    func bind() {
        refreshControl.rx.controlEvent(.valueChanged).subscribe(
            onNext: { [weak self] in
                self?.useCase.fetch()
            }
        ).disposed(by: disposeBag)

        useCase.feeds.asObservable().subscribe(onNext: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)

        useCase.feeds
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(
                onNext: { [weak self] indexPath in
                    guard let feed = self?.useCase.feeds.value[indexPath.row] else { return }
                    guard feed.contentType == Firebase.Post.ContentType.diary.rawValue else { return }
                    let vc = DiaryViewController(with: .init(diary: feed.diary!))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            )
            .disposed(by: disposeBag)
    }
}
