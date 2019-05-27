//
//  SwipingPhotoVC.swift
//  Tinder Firestore
//
//  Created by hosam on 5/27/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SwipingPhotoVC: UIPageViewController, UIPageViewControllerDataSource {
    
    let vcs = [
    PhotoVC(image: #imageLiteral(resourceName: "dismiss_circle")),
    PhotoVC(image: #imageLiteral(resourceName: "refresh_circle")),
    PhotoVC(image: #imageLiteral(resourceName: "like_circle")),
    PhotoVC(image: #imageLiteral(resourceName: "dismiss_down_arrow")),
    PhotoVC(image: #imageLiteral(resourceName: "super_like_circle"))
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        
          setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
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
    
    init(image:UIImage) {
         self.imageView.image = image
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
