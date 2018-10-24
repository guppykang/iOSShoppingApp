//
//  SwipingIntroViewController.swift
//  UserDeliveryApp
//
//  Created by Joshua Kang on 10/9/18.
//  Copyright © 2018 Joshua Kang. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    let pages = [
        Page(imageName: "JianYang", headerText : "Never go grocery shopping again!", footerText: "\n\n\n\nWe're delivering groceries right to your doorstep that will cost you less than how much you would spend in gas. Plus, you get to save your precious time."),
        Page(imageName: "phone", headerText : "Order", footerText: "\n\n\n\nOrder all the grocery items you want from your smartphone, set the order destination time, and it's on it's way!"),
        Page(imageName: "JianYangEating", headerText : "Delivery", footerText: "\n\n\n\nReceive your order at the specifed window of time, and enjoy the rest of your errands-free day!")
    ]
    
    
    private let previousButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        
        button.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.blue, for: .normal)
        
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let finishButton : UIButton = {
        print("inside last cell")
        let finishButton = UIButton(type: .system)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        finishButton.setTitle("FINISH", for: .normal)
        finishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        finishButton.setTitleColor(.green, for: .normal)
        
        finishButton.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        
        return finishButton
    }()
    
    
    
    
    @objc private func handleFinish() {
        print("segue to the sign up page")
        /*let vc = HomeViewController()
        self.present(vc, animated: true, completion: nil)*/
        
        /*let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let homeViewController = HomeViewController(collectionViewLayout : layout)
        self.present(homeViewController, animated: true, completion: nil) */
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let homeViewController = HomeViewController(collectionViewLayout : layout)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1

        setupBottomControls()
    }
    
    @objc private func handlePrevious() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage -= 1

        setupBottomControls()
    }
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .blue
        pc.pageIndicatorTintColor = .gray
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton, finishButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if(pageControl.currentPage == pageControl.numberOfPages - 1) {
            nextButton.isHidden = true
            finishButton.isHidden = false
        }
        else {
            finishButton.isHidden = true
            nextButton.isHidden = false
        }
        
        bottomControlsStackView.distribution = .fillEqually
        
        //        bottomControlsStackView.axis = .vertical
        view.addSubview(bottomControlsStackView)
        
        bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = (Int)(x/view.frame.width)
        setupBottomControls()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBottomControls()
        collectionView?.backgroundColor = .white
        //we need to do to let the dequeReusableCell know what kind of collectionView cell we're dealing with and what the identifier's name should be
        collectionView?.register(PageCellCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        //making the scrolling snappy instead of smooth
        collectionView?.isPagingEnabled = true
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCellCollectionViewCell
        
        //getting the appropriate page info
        let page = pages[indexPath.item]
        cell.page = page
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //creates the cells to be the length and height of the entire view
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    //we need this in order to make the changing of the cell's snappy and no spacing in between
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
