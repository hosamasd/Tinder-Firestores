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
    
    var cardsUser:CardViewModel? {
        didSet {
            vcs = cardsUser!.imageNames.map({ (imageUrl) -> UIViewController in
                let photoVC = PhotoVC(image: imageUrl)
                return photoVC
            })
            setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
             setupBarStackView()
        }
    }
    let deSelectedBar:UIColor = UIColor(white: 0, alpha: 0.1)
    
    let barStackView = UIStackView(arrangedSubviews: [])
    
    var vcs = [UIViewController]()
    fileprivate var isCardViewModel:Bool = false
    
    init(isCarViewMode:Bool = false) {
        self.isCardViewModel = isCarViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
       
        if isCardViewModel {
            disableSwipingAbility()
        }
        //          setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNextVC)))
    }
    
    @objc func handleNextVC(gesture:UITapGestureRecognizer)  {
        let currentVC = viewControllers!.first!
      
        if let index = self.vcs.firstIndex(of: currentVC) {
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = self.deSelectedBar})
            
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let minIndex = min(index + 1, vcs.count - 1)
                let nextVC = vcs[minIndex]
                setViewControllers([nextVC], direction: .forward, animated: false, completion: nil)
               print(minIndex)
                barStackView.arrangedSubviews[minIndex ].backgroundColor = .white
                
            }else {
                    let maxIndex = max(0, index - 1)
                    let previousVC = vcs[maxIndex]
                    setViewControllers([previousVC], direction: .forward, animated: false, completion: nil)
                    barStackView.arrangedSubviews[maxIndex ].backgroundColor = .white
                print(maxIndex)
                }
            
        }
    }
    
    func disableSwipingAbility()  {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    func setupBarStackView()  {
        cardsUser?.imageNames.forEach { (_) in
            let views = UIView()
            views.backgroundColor = deSelectedBar
            barStackView.addArrangedSubview(views)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        view.addSubview(barStackView)
        var paddingTop:CGFloat = 8
        if !isCardViewModel {
            paddingTop +=  UIApplication.shared.statusBarFrame.height
        }
        
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



extension SwipingPhotoVC:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentVC = viewControllers!.first
        guard let index = vcs.firstIndex(where: {$0==currentVC}) else { return  }
        barStackView.arrangedSubviews.forEach({$0.backgroundColor = deSelectedBar})
        
        barStackView.arrangedSubviews[index].backgroundColor = .white
    }
}
