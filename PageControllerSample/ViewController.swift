import UIKit

class ViewController: UIViewController {
    private var currentIndex: Int = 0
    private var pages: [UIViewController] = []
    private var pageViewController: UIPageViewController?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = true
        return scrollView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupPageViewController()
        setupRefreshControl()
    }

    private func setupPageViewController() {
        let page1 = DrawingViewController()
        page1.view.backgroundColor = .green
        let page2 = DrawingViewController()
        page2.view.backgroundColor = .blue

        pages = [page1, page2]

        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self

        addChild(pageViewController)
        scrollView.addSubview(pageViewController.view)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageViewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            pageViewController.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        pageViewController.didMove(toParent: self)
        self.pageViewController = pageViewController

        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    private func setupRefreshControl() {
        scrollView.refreshControl = refreshControl
        scrollView.bringSubviewToFront(refreshControl)
        NSLayoutConstraint.activate([
            refreshControl.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 32),
            refreshControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
    }

    @objc private func didPullRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
}
