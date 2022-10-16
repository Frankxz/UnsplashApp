//
//  InfoViewController.swift
//  UnsplashApp
//
//  Created by Robert Miller on 14.10.2022.
//

import UIKit

protocol InfoViewDelegate: Any {
    func actionButtonTapped()
    func showSizeButtonTapped()
}

class InfoView: UIView {
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private var currentHeight: CGFloat = 140
    private var maxHeight: CGFloat = (UIScreen.main.bounds.height * 0.17) * 2
    private let defaultHeight: CGFloat = 140
    
    var unsplashPhoto: UnsplashPhoto?
    var delegate: InfoViewDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let divideLineView: UIView = {
        let view =  UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.setupAppearence(image: UIImage(systemName: "heart"), title: nil)
        button.tintColor = .systemPink
        return button
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        button.setupAppearence(image: UIImage(systemName: "square.and.arrow.up"), title: nil)
        return button
    }()
    
    lazy var showfullSizeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(showSizeButtonTapped), for: .touchUpInside)
        button.setupAppearence(image: nil, title: "Original size")
        return button
    }()
    
    private let authorLabel = UILabel.makeInfoLabel(size: 30, color: .label)
    
    private let descriptionLabel = UILabel.makeInfoLabel(size: 22, color: .secondaryLabel)
    
    private let infoLabels: [UILabel] = {
        var labels: [UILabel] = []
        for parameter in DetailParameter.allCases {
            let label = UILabel.makeInfoLabel(size: 20, color: .label)
            labels.append(label);
        }
        return labels
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        setupPanGesture()
        configurePopUpView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeButtonTapped() {
        guard let photo = unsplashPhoto else {return}
        let isInFavorites = StorageManager.isInFavorites(unsplashPhoto: photo)
        isInFavorites ? StorageManager.deleteFromFavorites(photo) : StorageManager.save(photo)
        updateFavoriteButton()
    }
    
    @objc func actionButtonTapped() {
        delegate?.actionButtonTapped()
    }
    
    @objc func showSizeButtonTapped() {
        delegate?.showSizeButtonTapped()
    }
    
    func prepareInfoView(){
        authorLabel.text = nil
        descriptionLabel.text = nil
        containerViewHeightConstraint?.constant = defaultHeight
        layoutIfNeeded()
    }
    
    func updateInfoView(unsplashPhoto: UnsplashPhoto){
        self.unsplashPhoto = unsplashPhoto
        
        updateLabels()
        updateFavoriteButton()
        increaseContainerSize()
    }
}

// MARK: - Private methods
extension InfoView {
    
    private func updateFavoriteButton(){
        guard let unsplashPhoto = unsplashPhoto else { return }
        
        let isInFavorites = StorageManager.isInFavorites(unsplashPhoto: unsplashPhoto)
        let imageSystemName: String
        isInFavorites ? (imageSystemName = "heart.fill") : (imageSystemName = "heart")
        likeButton.setImage(UIImage(systemName: imageSystemName), for: .normal)
    }
    
    private func updateLabels() {
        guard let unsplashPhoto = unsplashPhoto else { return }
        
        authorLabel.text = unsplashPhoto.user?.name
        descriptionLabel.text = unsplashPhoto.description
        
        UIView.makeAlphaAnimate(elements: [authorLabel,descriptionLabel], duration: 0.5, delay: 0)
        
        let location = (unsplashPhoto.location?.country ?? "") + (unsplashPhoto.location?.city ?? "")
        let date = unsplashPhoto.created_at?.formatDate() ?? "unknown"
        
        infoLabels[0].text = "📍 Place: " + (location.isEmpty ? "unknown" : location)
        infoLabels[1].text = "🧷 Downloads: " + String(unsplashPhoto.downloads ?? 0)
        infoLabels[2].text = "📅 " + date
    }
    
    //  Made because in description field may be contained long string
    private func increaseContainerSize() {
        let newMaxHeight = 340 + CGFloat(descriptionLabel.numberOfVisibleLines * 20)
        if (newMaxHeight <= UIScreen.main.bounds.height) {
            maxHeight = newMaxHeight
        } else {
            maxHeight = UIScreen.main.bounds.height - 100
        }
    }
}


// MARK: - Constraints
extension InfoView {
    private func setConstraints() {
        
        let buttonsStackView = getButtonsStackView()
        let labelsStackView = getLabelsStackView()
        
        containerView.addSubview(buttonsStackView)
        containerView.addSubview(authorLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(divideLineView)
        containerView.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            //  buttonsStackView
            buttonsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 46),
            
            //  authorLabel
            authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            authorLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
            authorLabel.heightAnchor.constraint(equalToConstant: 40),

            //  descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 0),
            descriptionLabel.bottomAnchor.constraint(equalTo: divideLineView.topAnchor, constant: -20),

            //  divideLineView
            divideLineView.heightAnchor.constraint(equalToConstant: 3),
            divideLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            divideLineView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            divideLineView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),

            // infoLabelsStacView
            labelsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            labelsStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            labelsStackView.topAnchor.constraint(equalTo: divideLineView.bottomAnchor, constant: 20),
            labelsStackView.heightAnchor.constraint(equalToConstant: CGFloat(infoLabels.count * 30))
        ])
    }
    
    private func getLabelsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabels.forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }
    
    private func getButtonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(showfullSizeButton)
        stackView.addArrangedSubview(actionButton)
        stackView.addArrangedSubview(likeButton)
        
        showfullSizeButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 152).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        
        return stackView
    }
}

// MARK: -  Pop up  view logic
extension InfoView {
    func configurePopUpView(){
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: currentHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        containerViewBottomConstraint?.isActive = true
        containerViewHeightConstraint?.isActive = true
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case.changed:
            if newHeight < maxHeight && newHeight > defaultHeight {
                containerViewHeightConstraint?.constant = newHeight
                layoutIfNeeded()
            }
            
        case .ended:
            // If  new height < default animate back to default
            if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            // If new height < max and going down -> set to default height
            else if newHeight < maxHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            // If new height < max and going up -> set to max height
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maxHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.layoutIfNeeded()
            print(height)
        }
        currentHeight = height
    }
}
