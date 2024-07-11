//
//  PostsTableViewCell.swift
//  WaveEcho
//
//  Created by 박지은 on 4/22/24.
//

//import UIKit
//import SnapKit
//
//class PostsTableViewCell: BaseTableViewCell {
//    
//    var contents = {
//        let contents = UILabel()
//        contents.numberOfLines = 0
//        return contents
//    }()
//    
//    let photos = {
//        let photo = UIImageView()
//        photo.layer.borderWidth = 1
//        photo.layer.borderColor = UIColor.red.cgColor
//        return photo
//    }()
//    
//    let date = {
//        let date = UILabel()
//        date.textColor = .lightGray
//        date.font = .systemFont(ofSize: 10)
//        return date
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super .init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        contents.text = nil
//        date.text = nil
//        photos.image = nil
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//    }
//    
//    override func configureHierarchy() {
//        [contents, photos, date].forEach {
//            contentView.addSubview($0)
//        }
//    }
//    
//    override func configureConstraints() {
//        
//        contents.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(10)
//            $0.top.equalTo(contentView).offset(5)
//            $0.bottom.equalToSuperview().offset(-20)
//            $0.trailing.equalTo(photos.snp.leading).offset(-10)
//        }
//        
//        photos.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(10)
//            $0.top.equalTo(contents)
//            $0.size.equalTo(100)
//        }
//        
//        date.snp.makeConstraints {
//            $0.bottom.equalTo(contentView).offset(-10)
//            $0.trailing.equalTo(contentView).offset(-10)
//        }        
//    }
//    
//    override func configureView() {
//        
//        contentView.layer.cornerRadius = 20
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
