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

    let horizontalMargin: CGFloat = 12
    let verticalMargin: CGFloat = 12
    let horizontalMarginInner: CGFloat = 12

    lazy var userNameLabel: UILabel = {
        var label = UILabel.label(.headline)
        return label
    }()

    lazy var handleLabel: UILabel = {
        var label = UILabel.label(.footnote, textColour: UIColor.secondaryLabel)
        return label
    }()

    lazy var locationLabel: Label2 = {
        var label = Label2()
        label.aTitle = "Location"
        label.setupUI()
        return label
    }()

    lazy var userFollowersCountLabel: Label2 = {
        var label = Label2()
        label.aTitle = "Followers"
        label.setupUI()
        return label
    }()

    lazy var tweetCountLabel: Label2 = {
        var label = Label2()
        label.aTitle = "Tweets"
        label.setupUI()
        return label
    }()

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

    lazy var moreButton: UIButton = {
        var button = UIButton()
        button.setTitle(WidgetName.moreButton, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
        return button
    }()

    lazy var tweetFavouriteLabel: Label2 = {
        var label = Label2()
        label.aTitle = "Favourited"
        label.setupUI()
        return label
    }()

    lazy var tweetRetweetLabel: Label2 = {
        var label = Label2()
        label.aTitle = "Retweets"
        label.setupUI()
        return label
    }()

    lazy var tweetReplyLabel: Label2 = {
        var label = Label2()
        label.aTitle = "Replies"
        label.setupUI()
        return label
    }()

    lazy var topStack: UIStackView = {
        let stack = UIStackView.stack(horizontalMarginInner)
        return stack
    }()

    lazy var secondStack: UIStackView = {
        let stack = UIStackView.stack(horizontalMarginInner)
        return stack
    }()

    lazy var mapView: MKMapView = {
        var mapView = MKMapView()
        return mapView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showMoreInfo(false)
        presenter?.viewDidLoad()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterDetailsProtocol?

    @objc
    func showMore(_ sender: Any) {
        presenter?.showMore()
    }

    func showMoreInfo(_ show: Bool) {
        tweetFavouriteLabel.isHidden = !show
        tweetRetweetLabel.isHidden = !show
        tweetReplyLabel.isHidden = !show
        //        if self.presenter?.tweet?.hasGeoData == true && show {
        mapView.isHidden = !show
        //        }

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
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
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

        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(handleLabel)
        handleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(topStack)
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.addArrangedSubview(userFollowersCountLabel)
        topStack.addArrangedSubview(tweetCountLabel)

        //        view.addSubview(userFollowersCountLabel)
        //        userFollowersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        //
        //        view.addSubview(tweetCountLabel)
        //        tweetCountLabel.translatesAutoresizingMaskIntoConstraints = false

        //        view.addSubview(tweetLabel)
        //        tweetLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(secondStack)
        secondStack.translatesAutoresizingMaskIntoConstraints = false
        secondStack.addArrangedSubview(tweetFavouriteLabel)
        secondStack.addArrangedSubview(tweetReplyLabel)
        secondStack.addArrangedSubview(tweetRetweetLabel)

        //        view.addSubview(tweetFavouriteLabel)
        //        tweetFavouriteLabel.translatesAutoresizingMaskIntoConstraints = false
        //
        //        view.addSubview(tweetReplyLabel)
        //        tweetReplyLabel.translatesAutoresizingMaskIntoConstraints = false
        //
        //        view.addSubview(tweetRetweetLabel)
        //        tweetRetweetLabel.translatesAutoresizingMaskIntoConstraints = false

        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: verticalMargin),
            avatarImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin),
            //            avatarImageView.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -4),
            avatarImageView.widthAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            //            userNameLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: verticalMargin),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: horizontalMarginInner),
            userNameLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin),
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
            //            userNameLabel.heightAnchor.constraint(equalToConstant: 80)
            //            userNameLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -4)
        ])

        NSLayoutConstraint.activate([
            //            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            handleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            handleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: horizontalMargin),
            handleLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -verticalMargin)
        ])

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: verticalMargin),
            locationLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin),
            locationLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin)
        ])

        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: verticalMargin),
            topStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin),
            topStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin)
        ])

        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: verticalMargin),
            moreButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin)
        ])
    }

    func setupSecondPart() {

        let guide = view.safeAreaLayoutGuide

        if presenter?.tweet?.hasGeoData == true {
            view.addSubview(mapView)
            mapView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                mapView.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
                mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin),
                mapView.heightAnchor.constraint(equalToConstant: 160),
                mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin),
                mapView.bottomAnchor.constraint(equalTo: secondStack.topAnchor, constant: -verticalMargin),
                //                mapView.widthAnchor.constraint(equalToConstant: 300),
            ])
        } else {
            secondStack.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: verticalMargin).isActive = true
        }

        NSLayoutConstraint.activate([
            secondStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalMargin),
            secondStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalMargin)
        ])

    }
}
