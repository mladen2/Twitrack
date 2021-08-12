//
//  NetworkService.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//

import Foundation

class NetworkService: NSObject {

    let baseURL = "https://stream.twitter.com/1.1/statuses/filter.json"

    var decoder: JSONDecoder
    var session: URLSession?

    var httpMethod: HTTPMethod = .POST
    var currentTask: URLSessionDataTask?

    var delegate: NetworkDelegate?
    var theSearchTerms: String = ""

    var isStreaming: Bool {
        currentTask != nil && currentTask!.state == URLSessionTask.State.running
    }

    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
        super.init()
        let conf = URLSessionConfiguration.default
        //        conf.waitsForConnectivity = true
        self.session = URLSession(configuration: conf, delegate: self, delegateQueue: .current)
    }

    func startStreaming(completion: (Result<Bool, Error>) -> Void) {

//        theSearchTerms = paramTermsString(defaultSearchTerms)
//        let query = baseURL + URLRequestConstants.startParams + trackTerms(theSearchTerms)

        var arr2 = [String]()
//        let locs = [-122.75,36.8,-121.75,37.8] // san fran.
        // [long, lat]
        let locs = [13.218791,43.48012,21.225747,45.753836] // zag -> Sa
        // lon
//        let locs = [-0.206077,51.474422,-0.075958,51.537462] // lon
        for loc in locs {
            arr2.append("\(loc)")
        }

//        theSearchTerms = paramTermsString(defaultSearchTerms)
        theSearchTerms = paramTermsString(arr2)

        let query = baseURL + URLRequestConstants.startParams + locations()

        guard let url = URL(string: query) else {
            completion(.failure(LocalError.badURL(url: query)))
            return
        }

        let request = buildRequest(url)
        currentTask?.cancel()
        currentTask = session?.dataTask(with: request)
        currentTask?.resume()
        completion(.success(true))
    }

    func stop() {
        currentTask?.cancel()
    }
}

// MARK: -
// MARK: Request helper methods
// MARK: -
extension NetworkService {

    func buildRequest(_ url: URL) -> URLRequest {

        let cred = AuthHelper.fetchUserToken()

        var tw = TwitterAuthSignature(
            oauthConsumerKey: TwitterConstant.APIKey,
            oauthConsumerSecret: TwitterConstant.APISecretKey,
            oauthNonce: UUID().uuidString,
            oauthSignatureMethod: URLRequestConstants.method,
            oauthTimestamp: "\(Int(Date().timeIntervalSince1970))",
            oauthToken: cred?.accessToken?.key ?? "",
            oauthTokenSecret: cred?.accessToken?.secret ?? "",
            oauthVersion: URLRequestConstants.version,
//            otherParams: [StreamParamName.track: theSearchTerms]
            otherParams: [StreamParamName.locations: theSearchTerms]
        )

        let sig = HttpSignature(method: httpMethod, baseURL: baseURL, twitterAuthSigParams: tw)
        tw.oauthSignature = sig.sha1HmacSig()
        let userAuthString = Authorization.getAuthorizationString(tw.authorizationParams())

        var request = URLRequest(url: url)
        request.setValue(userAuthString, forHTTPHeaderField: POSTHeaderKey.authorization)

        request.httpMethod = httpMethod.rawValue
//        request.setValue(POSTHeaderValue.appJson, forHTTPHeaderField: POSTHeaderKey.contentType)
        request.setValue(POSTHeaderValue.appXForm, forHTTPHeaderField: POSTHeaderKey.contentType)
        return request
    }

    func trackTerms(_ searchParamsString: String) -> String {
        return StreamParamName.track + URLRequestConstants.paramDelimiter + searchParamsString
    }

    func locations() -> String {
        return StreamParamName.locations + URLRequestConstants.paramDelimiter + theSearchTerms
    }

    func paramTermsString(_ terms: [String]) -> String {
        guard !terms.isEmpty else { return "" }
        var str = ""
        for term in terms {
            str += term
            if term != terms.last {
                str += ","
            }
        }
        return str
    }
}

// MARK: -
// MARK: URL Session Delegate
// MARK: -
extension NetworkService: URLSessionDelegate, URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

//        pr("data: \(String(data: data, encoding: .utf8) ?? "")")
//        var anError: Error?

        do {
//            pr("data received: \(String(data: data, encoding: .utf8) ?? "")")
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tweet = try self.decoder.decode(Tweet.self, from: data)
            tweet.timeReceived = Date()
            delegate?.newTweet(tweet)

        } catch DecodingError.keyNotFound(let key, let context) {
            let msg = "could not find key \(key) in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showMessage(LocalError.jsonError(message: msg).localizedDescription)

        } catch DecodingError.valueNotFound(let type, let context) {
            let msg = "could not find type \(type) in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch DecodingError.typeMismatch(let type, let context) {
            let msg = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showMessage(LocalError.jsonError(message: msg).localizedDescription)
            // how to differentiate if it's an error?
//            let response = try? self.decoder.decode(TwitterErrors.self, from: data ?? Data())
//            pr("response.error: \(String(describing: response))")
//            let error = response?.errors.first
//            completion(.failure(NSError(domain: error?.message ?? msg, code: error?.code ?? -999, userInfo: nil)))
        } catch DecodingError.dataCorrupted(let context) {
            let msg = "data found to be corrupted in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch let error as NSError {
            let msg = "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)"
            pr(msg)
            delegate?.showMessage(LocalError.jsonError(message: msg).localizedDescription)
        } catch {
//            anError = error
            pr("error: \(error.localizedDescription)")
            delegate?.showError(error)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let error = error ?? LocalError.urlSessionCompletedWithError
        pr("error: \(error.localizedDescription)")
        delegate?.showError(error)
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        let error = error ?? LocalError.urlSessionBecameInvalid
        pr("error: \(error.localizedDescription)")
        delegate?.showError(error)
    }
}
