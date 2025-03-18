//
//  ViewController.swift
//  Zeo route
//
//  Created by Kudumala on 18/03/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var images: [UnsplashImage] = []
    private var currentPage = 1
    private var isLoading = false
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLoader()
        fetchImages()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3
        let totalSpacing = (itemsPerRow - 1) * layout.minimumInteritemSpacing
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2) // Adjust height dynamically
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    private func setupLoader() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    private func fetchImages() {
        guard !isLoading else { return }
        isLoading = true
        activityIndicator.startAnimating()
        
        Task {
            do {
                let newImages = try await APIManager.shared.fetchImages(page: currentPage)
                DispatchQueue.main.async {
                    self.images.append(contentsOf: newImages)
                    self.collectionView.reloadData()
                    self.currentPage += 1
                    self.isLoading = false
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                print("Failed to fetch images: \(error.localizedDescription)")
                self.isLoading = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let imageUrl = images[indexPath.item].urls?.small
        cell.configure(with: imageUrl)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace: CGFloat = 4
        let availableWidth = view.frame.width - (paddingSpace * (itemsPerRow - 1))
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // MARK: - Pagination Logic
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            fetchImages()
        }
    }
}

