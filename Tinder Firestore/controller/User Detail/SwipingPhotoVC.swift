//
//  SwipingPhotoVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import SDWebImage
class SwipingPhotoVC: UIPageViewController, UIPageViewControllerDataSource {
    
    var cardsUser:CardViewModel! {
        didSet {
            vcs = cardsUser.imageNames.map({ (imageUrl) -> UIViewController in
                let photoVC = PhotoVC(image: imageUrl)
                return photoVC
            })
             setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
        }
    }
    let deSelectedBar:UIColor = UIColor(white: 0, alpha: 0.1)
    
    let barStackView = UIStackView(arrangedSubviews: [])
    
    var vcs = [UIViewController]()
    
//    let vcs = [
//    PhotoVC(image: #imageLiteral(resourceName: "dismiss_circle")),
//    PhotoVC(image: #imageLiteral(resourceName: "refresh_circle")),
//    PhotoVC(image: #imageLiteral(resourceName: "like_circle")),
//    PhotoVC(image: #imageLiteral(resourceName: "dismiss_down_arrow")),
//    PhotoVC(image: #imageLiteral(resourceName: "super_like_circle"))
//    ]
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        setupBarStackView()
//          setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
        
    }
    
    func setupBarStackView()  {
        cardsUser.imageNames.forEach { (_) in
            let views = UIView()
            views.backgroundColor = deSelectedBar
            barStackView.addArrangedSubview(views)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        view.addSubview(barStackView)
        let paddingTop = UIApplication.shared.statusBarFrame.height + 8
        
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      
        
        let index = self.vcs.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {
            return nil
        }
        return vcs[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
         let index = self.vcs.firstIndex(where: {$0 == viewController}) ?? 0
        if index == vcs.count - 1 {
            return nil
        }
        return vcs[index + 1]
    }
}

class PhotoVC: UIViewController {
    var imageView = UIImageView()
    
    init(image:String) {
        if let url = URL(string: image) {
            self.imageView.sd_setImage(with: url)
        }
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      view.addSubview(imageView)
        imageView.fillSuperview()
    }
    
}

extension SwipingPhotoVC:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentVC = viewControllers!.first
        guard let index = vcs.firstIndex(where: {$0==currentVC}) else { return  }
        barStackView.arrangedSubviews.forEach({$0.backgroundColor = deSelectedBar})
        
        barStackView.arrangedSubviews[index].backgroundColor = .white
    }
}
