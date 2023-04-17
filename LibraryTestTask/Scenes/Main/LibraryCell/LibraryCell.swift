//
//  CollectionViewCell.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import UIKit

class LibraryCell: UICollectionViewCell {
    
    static let identifier = "libraryCell"
    
    lazy private var coverImageView: CoverImageView = {
        let imageView = CoverImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = CGSizeZero
        imageView.layer.shadowRadius = 5
        return imageView
    }()
    
    lazy private var  titleBookLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var  publishDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = label.font?.withSize(10)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewModel: LibraryCellViewModelViewModelProtocol? {
        didSet {
            if let viewModel {
                coverImageView.fetchImage(with: viewModel.fullUrlCoverImage)
                titleBookLabel.text = viewModel.titleBook
                publishDateLabel.text = viewModel.publishDate
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addUIElements()
        setConstraint()
        setContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addUIElements() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleBookLabel)
        contentView.addSubview(publishDateLabel)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            coverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            coverImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            coverImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleBookLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 5),
            titleBookLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            titleBookLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
            
            publishDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            publishDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            publishDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5)
        ])
    }
    
    private func setContentView() {
        contentView.backgroundColor = .none
        contentView.layer.cornerRadius = 5
    }
    
}
