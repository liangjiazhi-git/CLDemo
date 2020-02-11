//
//  CLChatAlbumContentView.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatPhotoAlbumContentView: UIView {
    ///顶部工具条
    private lazy var topToolBar: UIView = {
        let topToolBar = UIView()
        return topToolBar
    }()
    ///collectionView
     private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.red
         return collectionView
     }()
    ///底部工具条
    private lazy var bottomToolBar: UIView = {
        let bottomToolBar = UIView()
        return bottomToolBar
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegate {
    private func initUI() {
        addSubview(topToolBar)
        addSubview(collectionView)
        addSubview(bottomToolBar)
    }
    private func makeConstraints() {
        topToolBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
            make.bottom.equalTo(bottomToolBar.snp.top)
        }
    }
}
