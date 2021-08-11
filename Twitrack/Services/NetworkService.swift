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

    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
        super.init()
        let conf = URLSessionConfiguration.default
        //        conf.waitsForConnectivity = true
        self.session = URLSession(configuration: conf, delegate: self, delegateQueue: .current)
    }

    func startStreaming(completion: (Result<Bool, Error>) -> Void) {

        theSearchTerms = searchTermsString(defaultSearchTerms)
        let query = baseURL + URLRequestConstants.startParams + trackTerms(theSearchTerms)

        guard let url = URL(string: query) else {
            completion(.failure(LocalError.badURL(query)))
            return
        }

        let request = buildRequest(url)
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
            otherParams: [StreamParamName.track: theSearchTerms]
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

    func searchTermsString(_ terms: [String]) -> String {
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

        pr("data: \(String(data: data, encoding: .utf8) ?? "")")
//        var anError: Error?

        do {
            pr("data received: \(String(data: data, encoding: .utf8) ?? "")")
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tweet = try self.decoder.decode(Tweet.self, from: data)
            tweet.timeReceived = Date()
            delegate?.newTweet(tweet)

        } catch DecodingError.keyNotFound(let key, let context) {
            let msg = "could not find key \(key) in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showError(LocalError.jsonError(msg))

        } catch DecodingError.valueNotFound(let type, let context) {
            let msg = "could not find type \(type) in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showError(LocalError.jsonError(msg))
        } catch DecodingError.typeMismatch(let type, let context) {
            let msg = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showError(LocalError.jsonError(msg))
            // how to differentiate if it's an error?
//            let response = try? self.decoder.decode(TwitterErrors.self, from: data ?? Data())
//            pr("response.error: \(String(describing: response))")
//            let error = response?.errors.first
//            completion(.failure(NSError(domain: error?.message ?? msg, code: error?.code ?? -999, userInfo: nil)))
        } catch DecodingError.dataCorrupted(let context) {
            let msg = "data found to be corrupted in JSON: \(context.debugDescription)"
            pr(msg)
            delegate?.showError(LocalError.jsonError(msg))
        } catch let error as NSError {
            let msg = "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)"
            pr(msg)
            delegate?.showError(LocalError.jsonError(msg))
        } catch {
//            anError = error
            pr("error: \(error.localizedDescription)")
            delegate?.showError(error)
        }
    }
}
