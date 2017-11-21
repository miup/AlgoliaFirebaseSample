//
//  UserViewController.swift
//  AlgoliaFirebaseSample
//
//  Created by kazuya-miura on 2017/11/12.
//  Copyright © 2017 kazuya-miura. All rights reserved.
//

import UIKit
import RxSwift

class UsersViewController: ViewController {
    private let useCase = UsersUseCase()
    private let dataSource = UsersDataSource()
    private let disposeBag = DisposeBag()

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
        view.registerNib(type: UserCell.self)
        view.rowHeight = UITableViewAutomaticDimension
        view.tableHeaderView = searchController.searchBar
        view.tableFooterView = UIView()
        return view
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "ユーザー"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "ユーザー"
    }

    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        useCase.fetch()
    }

    func bind() {
        useCase.users
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
