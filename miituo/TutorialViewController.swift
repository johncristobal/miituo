//
//  TutorialViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 20/04/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!

    var tutorialPageViewController: OnboardingViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tutorialPageViewController = segue.destination as? OnboardingViewController {
            OnboardingViewController.tutorialDelegate = self
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageControl.addTarget(self, action: "didChangePageControlValue", for: .valueChanged)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? OnboardingViewController {
            //tutorialPageViewController.tutorialDelegate = self as! OnboardingViewControllerDelegate
            self.tutorialPageViewController = tutorialPageViewController
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension TutorialViewController: OnboardingViewControllerDelegate {
    
    func onboardingViewController(tutorialPageViewController: OnboardingViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onboardingViewController(tutorialPageViewController: OnboardingViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
