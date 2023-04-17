//
//  DetailsBookViewController.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import UIKit

class DetailsBookViewController: UIViewController {
    
    lazy private var coverImageView: CoverImageView = {
        let imageView = CoverImageView()
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = CGSizeZero
        imageView.layer.shadowRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy private var titleBookLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var publishYearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = label.font?.withSize(22)
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = label.font?.withSize(22)
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = label.font?.withSize(20)
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .none
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var overlayActivityView = UIView()
    private lazy var activityIndicatorView = UIActivityIndicatorView()

    private var viewModel: DetailsBookViewControllerViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setFillinginTheData()
        addUIElements()
        setNavigationBar()
        setConstraint()
    }

    init(viewModel: DetailsBookViewControllerViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addUIElements() {
        view.addSubview(coverImageView)
        view.addSubview(titleBookLabel)
        view.addSubview(publishYearLabel)
        view.addSubview(ratingLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionLabel)    }

    private func setNavigationBar() {
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        navigationController?.navigationBar.topItem?.backButtonTitle = "Library"
        navigationController?.navigationBar.tintColor = .brown
        navigationItem.title = "Details of book"
        navigationItem.largeTitleDisplayMode = .never
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            coverImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            coverImageView.heightAnchor.constraint(equalToConstant: 200),
            coverImageView.widthAnchor.constraint(equalToConstant: 120),

            titleBookLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleBookLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 20),
            titleBookLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            titleBookLabel.heightAnchor.constraint(equalToConstant: 100),

            publishYearLabel.topAnchor.constraint(equalTo: titleBookLabel.bottomAnchor, constant: 10),
            publishYearLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 20),
            publishYearLabel.heightAnchor.constraint(equalToConstant: 22),

            ratingLabel.topAnchor.constraint(equalTo: publishYearLabel.bottomAnchor, constant: 10),
            ratingLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 22),

            scrollView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),

            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width-32)
        ])
    }

    private func setFillinginTheData() {
        coverImageView.fetchImage(with: viewModel.fullUrlCoverImage)
        titleBookLabel.text = viewModel.titleBook
        publishYearLabel.text = viewModel.publishDate
        viewModel.fetchRating{
            self.ratingLabel.text = self.viewModel.rating
        }
        viewModel.fetchDescription {
            self.descriptionLabel.text = self.viewModel.description
        }

    }

}
