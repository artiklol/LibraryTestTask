//
//  MainViewController.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import UIKit

class MainViewController: UIViewController {

    private lazy var libraryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "MainBackgroundColor")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var overlayActivityView = UIView()
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private var viewModel: MainViewControllerViewModelProtocol? {
        didSet {
            checkStatusCode()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewControllerViewModel()

        libraryCollectionView.register(LibraryCell.self,
                                       forCellWithReuseIdentifier: LibraryCell.identifier)

        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self

        addUIElements()
        setConstraint()
        setNavigationBar()
        startActivityView()
    }

    private func addUIElements() {
        view.addSubview(libraryCollectionView)
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Library of books"
        navigationController?.navigationBar.isHidden = true

        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.brown
        ]
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            libraryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            libraryCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            libraryCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            libraryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func startActivityView() {
        overlayActivityView.backgroundColor = UIColor(named: "CellBackgroundColor")?.withAlphaComponent(0.7)
        overlayActivityView.frame = view.frame
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = .brown
        activityIndicatorView.center = CGPoint(x: overlayActivityView.bounds.width / 2,
                                               y: overlayActivityView.bounds.height / 2)
        overlayActivityView.addSubview(activityIndicatorView)
        view.addSubview(overlayActivityView)
        activityIndicatorView.startAnimating()
    }

    private func stopActivityView() {
        activityIndicatorView.stopAnimating()
        overlayActivityView.removeFromSuperview()
    }

    private func checkStatusCode() {
        guard let viewModel else { return }
        viewModel.fetchLibrary {
            if viewModel.books.count > 0 {
                DispatchQueue.main.async {
                    self.libraryCollectionView.reloadData()
                    self.navigationController?.navigationBar.isHidden = false
                    self.stopActivityView()
                }
            } else {
                self.showAlertStatusCodeError(statusCode: viewModel.statusCode)
            }
        }

    }

    private func showAlertStatusCodeError(statusCode: Int) {
        let alert = UIAlertController(title: "Status code \(statusCode)",
                                      message: "An unknown network error has occurred. " +
                                      "Data could not be retrieved.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Repeat again", style: .default) { _ in
            self.startActivityView()
            self.checkStatusCode()
        })
        stopActivityView()
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCell.identifier,
                                                            for: indexPath) as? LibraryCell else {
            return LibraryCell()
        }

        cell.viewModel = viewModel?.cellViewModel(at: indexPath)
        return cell
    }

}

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.selectedCell(for: indexPath)
        guard let bookViewModel = viewModel?.viewModelForSelectedCell() else { return }
        let detailsBook = DetailsBookViewController(viewModel: bookViewModel)
        navigationController?.pushViewController(detailsBook, animated: true)
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.width - 120
        let cellWidth = (availableWidth / 3) + 10
        return CGSize(width: cellWidth, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

}
