//
//  SearchViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: ViewController {

    let useCase = SearchUseCase()
    let dataSource = SearchDataSource()
    let disposeBag = DisposeBag()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.rx.text.asDriver().drive(useCase.text).disposed(by: disposeBag)
        return searchController
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .plain)
        view.registerNib(type: FeedCell.self)
        view.rowHeight = UITableViewAutomaticDimension
        view.tableHeaderView = searchController.searchBar
        return view
    }()

    private lazy var locationEnabledSwitch: UISwitch = {
        let locationEnabledSwitch = UISwitch()
        locationEnabledSwitch.rx.value.asDriver().drive(useCase.isLocationEnabled).disposed(by: disposeBag)
        return locationEnabledSwitch
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "検索"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "検索"
    }

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationEnabledSwitch)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        useCase.search()
    }

    func bind() {
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

