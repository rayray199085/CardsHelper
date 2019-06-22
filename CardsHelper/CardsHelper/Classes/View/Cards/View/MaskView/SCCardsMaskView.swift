//
//  SCCardsMaskView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 22/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
protocol SCCardsMaskViewDelegate: NSObjectProtocol {
    func didClickImageMaskButton(view: SCCardsMaskView?)
}
class SCCardsMaskView: UIView {
    private var cellImageViewCenterPoint: CGPoint?
    
    class func cardsMaskView()->SCCardsMaskView{
        let nib = UINib(nibName: "SCCardsMaskView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCCardsMaskView
        v.frame = UIScreen.main.bounds
        return v
    }
    func setImage(centerPoint: CGPoint, image: UIImage?){
        cardsImageView.image = image
        cellImageViewCenterPoint = centerPoint
        cardsImageView.addPopHorizontalAnimation(fromValue: centerPoint.x, toValue: center.x, springBounciness: 12)
        cardsImageView.addPopVerticalAnimation(fromValue: centerPoint.y, toValue: center.y, springBounciness: 12)
        cardsImageView.addPopScaleAnimation(fromValue: 137 / cardsImageView.bounds.width, toValue: 1.0, duration: 0.25)
    }
    weak var delegate: SCCardsMaskViewDelegate?
    
    @IBOutlet weak var cardsImageView: UIImageView!
    
    @IBAction func clickImageMaskButton(_ sender: Any) {
        cardsImageView.addPopHorizontalAnimation(fromValue: center.x, toValue: cellImageViewCenterPoint?.x ?? center.x)
        cardsImageView.addPopVerticalAnimation(fromValue: center.y, toValue: cellImageViewCenterPoint?.y ?? center.y)
        cardsImageView.addPopScaleAnimation(toValue: 137 / cardsImageView.bounds.width, duration: 0.25) { [weak self](_, _) in
            self?.delegate?.didClickImageMaskButton(view: self)
        }
    }
}
