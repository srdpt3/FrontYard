//
//  PagedScrollViewController.swift
//  ScrollViews
//
//

import UIKit

class PagedScrollViewController: UIViewController, UIScrollViewDelegate {
    
  //  @IBOutlet var scrollView: UIScrollView!
    
   // var scrollView = UIScrollView()
    
    
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    
   // @IBOutlet var pageControl: UIPageControl!

    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
            // Initialization of UIScrollView
        self.scrollView = UIScrollView()
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.scrollView.frame = CGRect(x: 0, y: height*0.15, width: width, height: height*0.65)
        self.scrollView.pagingEnabled = true
        self.scrollView.scrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        
        self.pageControl.frame = CGRectMake(0, height*0.8, view.frame.size.width, 25)

        
        
     //   self.pageControl.tintColor = UIColor.redColor()
      //  self.pageControl.pageIndicatorTintColor = UIColor.blackColor()
       // self.pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        self.view.addSubview(pageControl)
        
        
        self.view.addSubview(scrollView)
        
        
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(doubleTapRecognizer)
        
        
   //     self.view.addSubview(pageControl)
        // 1
        pageImages = [UIImage(named:"photo1.png")!,
        UIImage(named:"photo2.png")!,
        UIImage(named:"photo3.png")!,
        UIImage(named:"photo4.png")!,
        UIImage(named:"photo5.png")!]

       let pageCount = pageImages.count

        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount

        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
                
        // 5
        loadVisiblePages()
    }

    func loadPage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }

        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = UIViewContentMode.ScaleAspectFit
            newPageView.frame = frame
            
    
          newPageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin.union(UIViewAutoresizing.FlexibleHeight).union(UIViewAutoresizing.FlexibleRightMargin).union(UIViewAutoresizing.FlexibleLeftMargin).union(UIViewAutoresizing.FlexibleTopMargin ).union(UIViewAutoresizing.FlexibleWidth)
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {

        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
        
    func showInView(aView: UIView!, animated: Bool)
    {
        aView.addSubview(self.view)
        //  logoImg!.image = image
        //   messageLabel!.text = message
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }


    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
            removeAnimate()
    }

   
    override func viewWillAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        
        self.navigationController?.navigationBar
        //  self.navigationItem.titleView = logoButton
        nav?.backgroundColor = UIColor(red: 233/255, green: 143/255, blue: 143/255, alpha: 1.0)
        //nav?.tintColor = UIColor(red: 31/255, green: 96/255, blue: 246/255, alpha: 1.0)
        
        
        
        self.view.backgroundColor = UIColor.blackColor()

    }
    override func viewWillDisappear(animated: Bool) {
 
        
        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
