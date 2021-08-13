//
//  DetailsViewController.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 11/08/2021.
//  
//

import UIKit
import MapKit

struct WidgetName {
    static let moreButton = "Show More..."
}

class DetailsViewController: UIViewController {

    let horizontalMargin: CGFloat = 20
    let verticalMargin: CGFloat = 20
    let horizontalMarginInner: CGFloat = 12

    lazy var topSectionView: UIView = {
        var view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var userNameLabel: UILabel = { UILabel.label(.headline) }()
    lazy var handleLabel: UILabel = { UILabel.label(.footnote, textColour: UIColor.secondaryLabel) }()
    lazy var locationLabel: UILabel = { UILabel.label() }()
    lazy var userFollowersCountLabel: UILabel = { UILabel.label() }()
    lazy var followersTitleLabel: UILabel = { UILabel.label(.footnote, text: "Followers", textColour: UIColor.secondaryLabel) }()
    lazy var tweetCountLabel: UILabel = { UILabel.label() }()
    lazy var tweetsTitleLabel: UILabel = { UILabel.label(.footnote, text: "Tweets", textColour: UIColor.secondaryLabel) }()

    lazy var avatarImageView: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    lazy var tweetLabel: UILabel = {
        var label = UILabel.label()
        label.numberOfLines = 0
        return label
    }()

//    lazy var moreButton: UIButton = {
//        var button = UIButton()
//        button.setTitle(WidgetName.moreButton, for: .normal)
//        button.setTitleColor(UIColor.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
//        button.showsTouchWhenHighlighted = true
//        return button
//    }()

    lazy var tweetFavouriteLabel: UILabel = { UILabel.label() }()
    lazy var tweetRetweetLabel: UILabel = { UILabel.label() }()
    lazy var tweetReplyLabel: UILabel = { UILabel.label() }()
    lazy var topStack: UIStackView = { UIStackView.stack(horizontalMarginInner) }()
    lazy var bottomStack: UIStackView = { UIStackView.stack(horizontalMarginInner) }()
    lazy var mapView: MKMapView = { MKMapView() }()

    // portrait constraints
    var topSectionTrailingPortrait: NSLayoutConstraint!
    var mapTopPortrait: NSLayoutConstraint!
    var mapHeightPortrait: NSLayoutConstraint!
    var mapLeadingPortrait: NSLayoutConstraint!
    var bottomStackTopPortrait: NSLayoutConstraint!

    // landscape constraints
    var topSectionWidthLandscape: NSLayoutConstraint!
    var mapTopLandscape: NSLayoutConstraint!
    var mapBottomLandscape: NSLayoutConstraint!
    var mapWidthLandscape: NSLayoutConstraint!
    var mapLeadingLandscape: NSLayoutConstraint!
    var bottomStackTopLandscape: NSLayoutConstraint!

    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []

    var shouldShowMap: Bool = false

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showMoreInfo(false)
        presenter?.viewDidLoad()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterDetailsProtocol?

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        activateConstraints()
    }

    @objc
    func showMore(_ sender: Any) {
        presenter?.showMore()
    }

    func showMoreInfo(_ show: Bool) {
        tweetFavouriteLabel.isHidden = !show
        tweetRetweetLabel.isHidden = !show
        tweetReplyLabel.isHidden = !show
        bottomStack.isHidden = !show
        mapView.isHidden = !show

        if show {
            if let loc = fetchLocation() {
                showLocation(loc)
            }
        }
    }

    func fetchLocation() -> CLLocationCoordinate2D? {
        guard let coords = presenter?.coordinates else { return nil }
        let centre = CLLocationCoordinate2D(latitude: coords.lattitude, longitude: coords.longitude)
        return centre
    }

    func showLocation(_ location: CLLocationCoordinate2D) {

        let a = MKPointAnnotation()
        a.coordinate = location
        a.title = "Tweet Location"
        mapView.addAnnotation(a)

        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension DetailsViewController: PresenterToViewDetailsProtocol {

    func onFetchSuccess() {
        DispatchQueue.main.async {
            if let tweet = self.presenter?.tweet {
                self.userNameLabel.text = tweet.user.name
                self.handleLabel.text = "@" + tweet.user.screenName
                self.locationLabel.text = tweet.user.location
                self.avatarImageView.image = tweet.user.avatarImage

                self.userFollowersCountLabel.text = "\(tweet.user.followersCount.decimal)"
                self.tweetCountLabel.text = "\(tweet.user.statusesCount.decimal)"
                //                self.tweetLabel.attributedText = tweet.textHighlighted

                self.tweetFavouriteLabel.text = "\(tweet.favoriteCount.decimal)"
                self.tweetRetweetLabel.text = "\(tweet.retweetCount.decimal)"
                self.tweetReplyLabel.text = "\(tweet.replyCount ?? 0)"
                self.shouldShowMap = self.presenter?.tweet?.hasGeoData == true
                self.setupSecondPart()
            }
        }
    }

    // TODO: Implement View Output Methods
    func onMoreFetched() {
        DispatchQueue.main.async {
            if (self.presenter?.tweet) != nil {
                self.showMoreInfo(true)
            }
        }
    }

    func onError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
            }
        }
    }
}

extension DetailsViewController {

    func setupUI() {

        navigationItem.title = "Tweet Details"
        view.backgroundColor = UIColor.systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show More...", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMore(_:)))

        setupTopSection()

        view.addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        //        let favourite = UIStackView.stack(4)
        bottomStack.addArrangedSubview(UIImageView.imageView(with: "heart"))
        bottomStack.addArrangedSubview(tweetFavouriteLabel)
        //        secondStack.addArrangedSubview(favourite)

        let reply = UIStackView.stack(4)
        reply.addArrangedSubview(UIImageView.imageView(with: "bubble.left"))
        reply.addArrangedSubview(tweetReplyLabel)
        bottomStack.addArrangedSubview(reply)

        let retweet = UIStackView.stack(4)
        retweet.addArrangedSubview(UIImageView.imageView(with: "arrow.2.squarepath"))
        retweet.addArrangedSubview(tweetRetweetLabel)
        bottomStack.addArrangedSubview(retweet)
    }

    func setupTopSection() {

        view.addSubview(topSectionView)
        topSectionView.translatesAutoresizingMaskIntoConstraints = false

        topSectionView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        topSectionView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        topSectionView.addSubview(handleLabel)
        handleLabel.translatesAutoresizingMaskIntoConstraints = false

        topSectionView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        topSectionView.addSubview(topStack)
        topStack.translatesAutoresizingMaskIntoConstraints = false
        //        topStack.addArrangedSubview(locationLabel)

        let followers = UIStackView.stack(4)
        followers.addArrangedSubview(userFollowersCountLabel)
        followers.addArrangedSubview(followersTitleLabel)
        topStack.addArrangedSubview(followers)

        let tweets = UIStackView.stack(4)
        tweets.addArrangedSubview(tweetCountLabel)
        tweets.addArrangedSubview(tweetsTitleLabel)
        topStack.addArrangedSubview(tweets)

//        topSectionView.addSubview(moreButton)
//        moreButton.translatesAutoresizingMaskIntoConstraints = false

        setupTopSectionCommonConstraints()
        setupTopSectionPortraitConstraints()
        setupTopSectionLandscapeConstraints()
    }

    func setupTopSectionCommonConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topSectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            topSectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topSectionView.topAnchor, constant: verticalMargin),
            avatarImageView.leadingAnchor.constraint(equalTo: topSectionView.leadingAnchor, constant: horizontalMargin),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48)
        ])

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topSectionView.topAnchor, constant: verticalMargin),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: horizontalMargin),
            userNameLabel.trailingAnchor.constraint(equalTo: topSectionView.trailingAnchor, constant: -horizontalMargin),
        ])

        NSLayoutConstraint.activate([
            handleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            handleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: horizontalMargin),
        ])

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: verticalMargin),
            locationLabel.leadingAnchor.constraint(equalTo: topSectionView.leadingAnchor, constant: horizontalMargin),
            locationLabel.trailingAnchor.constraint(equalTo: topSectionView.trailingAnchor, constant: -horizontalMargin)
        ])

        let trailingTopStack = topStack.trailingAnchor.constraint(greaterThanOrEqualTo: topSectionView.trailingAnchor, constant: -horizontalMargin)
        trailingTopStack.priority = .defaultLow
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: verticalMargin),
            topStack.leadingAnchor.constraint(equalTo: topSectionView.leadingAnchor, constant: horizontalMargin),
            trailingTopStack
        ])

//        NSLayoutConstraint.activate([
//            moreButton.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: verticalMargin),
//            moreButton.leadingAnchor.constraint(equalTo: topSectionView.leadingAnchor, constant: horizontalMargin)
//        ])
    }

    func setupTopSectionPortraitConstraints() {
        let guide = view.safeAreaLayoutGuide
        topSectionTrailingPortrait = topSectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        portraitConstraints.append(topSectionTrailingPortrait)
    }

    func setupBottomSectionPortraitConstraints() {

        let guide = view.safeAreaLayoutGuide

        if shouldShowMap {
            // map
            mapTopPortrait = mapView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: verticalMargin)
            portraitConstraints.append(mapTopPortrait)

            mapLeadingPortrait = mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin)
            portraitConstraints.append(mapLeadingPortrait)

            mapHeightPortrait = mapView.heightAnchor.constraint(equalToConstant: 300)
            portraitConstraints.append(mapHeightPortrait)
            bottomStackTopPortrait = bottomStack.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: verticalMargin)
        } else {
            bottomStackTopPortrait = bottomStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: verticalMargin)
        }

        // bottom stack
        portraitConstraints.append(bottomStackTopPortrait)
    }

    func setupTopSectionLandscapeConstraints() {
        topSectionWidthLandscape = topSectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        landscapeConstraints.append(topSectionWidthLandscape)
    }

    func setupBottomSectionLandscapeConstraints() {

        let guide = view.safeAreaLayoutGuide
        if shouldShowMap {
            // map
            mapWidthLandscape = mapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
            landscapeConstraints.append(mapWidthLandscape)

            mapTopLandscape = mapView.topAnchor.constraint(equalTo: guide.topAnchor, constant: verticalMargin)
            landscapeConstraints.append(mapTopLandscape)

            mapBottomLandscape = mapView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -verticalMargin)
            landscapeConstraints.append(mapBottomLandscape)
        }

        // bottom stack
        bottomStackTopLandscape = bottomStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: verticalMargin)
        landscapeConstraints.append(bottomStackTopLandscape)
    }

    func setupSecondPart() {

        let guide = view.safeAreaLayoutGuide

        if shouldShowMap {
            view.addSubview(mapView)
            mapView.translatesAutoresizingMaskIntoConstraints = false
            mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin).isActive = true
        } else {
            bottomStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: verticalMargin).isActive = true
        }

        let trailing = bottomStack.trailingAnchor.constraint(greaterThanOrEqualTo: guide.trailingAnchor, constant: -horizontalMargin)
        trailing.priority = .defaultLow
        NSLayoutConstraint.activate([
            bottomStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin),
            trailing
        ])
        setupBottomSectionPortraitConstraints()
        setupBottomSectionLandscapeConstraints()
        activateConstraints()
    }

    func activateConstraints() {
        if OrientationHelper.isPortrait {
            NSLayoutConstraint.activate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeConstraints)
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
}
