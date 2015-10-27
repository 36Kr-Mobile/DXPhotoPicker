//
//  DXAssetCell.swift
//  DXPhotoPickerDemo
//
//  Created by DingXiao on 15/10/26.
//  Copyright © 2015年 Dennis. All rights reserved.
//

import UIKit
import Photos

@available(iOS 8.0, *)
class DXAssetCell: UICollectionViewCell {

// MARK: properties
    private var asset: PHAsset?
    
    private var selectItemBlock: ((selectItem: Bool, asset: PHAsset) -> Void)?
    
    private lazy var imageView: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "assets_placeholder_picture"))
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: Selector("checkButtonAction"), forControlEvents: .TouchUpInside)
        return button
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imv = UIImageView(frame: CGRectZero)
        imv.contentMode = .ScaleAspectFit
        imv.translatesAutoresizingMaskIntoConstraints = false
        return imv
    }()
    
    override var selected: Bool {
        set {
            super.selected = newValue
            if newValue == true {
                self.checkImageView.image = UIImage(named: "photo_check_selected")
                UIView.animateWithDuration(0.2,
                    animations: {
                        [unowned self] () -> Void in
                        self.checkImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);},
                    completion: {
                        [unowned self](stop) -> Void in
                        UIView.animateWithDuration(0.2, animations: { [unowned self]() -> Void in
                            self.checkImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        })
                })
            } else {
                self.checkImageView.image = UIImage(named: "photo_check_default")
            }
        }
        get {
            return super.selected
        }
    }
    
// MARK: life time
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForReuse() {
    }

// MARK: public methods

    func fillWithAsset(asset: PHAsset, isAssetSelected: Bool) {
        self.asset = asset
        DXPickerManager.fetchImageWithAsset(self.asset, targetSize: self.imageView.frame.size) {
            [weak self](image) -> Void in
            self!.imageView.image = image
        }
        self.selected = isAssetSelected
    }
    
    func selectItemBlock(block: (selectItem: Bool, asset: PHAsset) -> Void) {
        self.selectItemBlock = block
    }

    
// MARK: convenience
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(checkImageView)
        contentView.addSubview(checkButton)
        let viewBindingsDict = [
            "posterImageView":imageView,
            "checkButton": checkButton,
            "checkImageView": checkImageView
        ]
        let mertic = ["sideLength": 25]
        let imageViewVFLV = "V:|-0-[posterImageView]-0-|"
        let imageViewVFLH = "H:|-0-[posterImageView]-0-|"
        let imageViewContraintsV = NSLayoutConstraint.constraintsWithVisualFormat(
            imageViewVFLV,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewBindingsDict
        )
        let imageViewContraintsH = NSLayoutConstraint.constraintsWithVisualFormat(
            imageViewVFLH,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewBindingsDict
        )
        let checkImageViewVFLH = "H:[checkImageView(sideLength)]-3-|"
        let checkImageViewVFLV = "V:|-3-[checkImageView(sideLength)]"
        let checkImageViewContrainsH = NSLayoutConstraint.constraintsWithVisualFormat(
            checkImageViewVFLH,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: mertic,
            views: viewBindingsDict
        )
        let checkImageViewContrainsV = NSLayoutConstraint.constraintsWithVisualFormat(
            checkImageViewVFLV,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: mertic,
            views: viewBindingsDict
        )
        let checkConstraitRight = NSLayoutConstraint(
            item: checkButton,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0
        )
        let checkConstraitTop = NSLayoutConstraint(
            item: checkButton,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0
        )
        let checkContraitWidth = NSLayoutConstraint(
            item: checkButton,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: imageView,
            attribute: .Width,
            multiplier: 0.5,
            constant: 0
        )
        let checkConsraintHeight = NSLayoutConstraint(
            item: checkButton,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: checkButton,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0
        )
        addConstraints(imageViewContraintsV)
        addConstraints(imageViewContraintsH)
        addConstraints(checkImageViewContrainsH)
        addConstraints(checkImageViewContrainsV)
        addConstraints([checkConstraitRight,checkConstraitTop,checkContraitWidth,checkConsraintHeight])
    }
    

    
// MARK:UI actions
    @objc private func checkButtonAction() {
        self.selected = !self.selected
        guard self.selectItemBlock != nil else {
            return
        }
        self.selectItemBlock!(selectItem: self.selected, asset: self.asset!)
    }
}