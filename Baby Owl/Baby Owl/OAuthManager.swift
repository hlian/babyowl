//
//  OAuth.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

enum OAuthState {
    case Asleep
    case Error
    case RequestTokenObtained
}

extension String {
    func HMACSHA1(key: String) -> String {
        let length = Int(CC_SHA1_DIGEST_LENGTH)
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        let cKey = key.cStringUsingEncoding(NSUTF8StringEncoding)!
        let cData = self.cStringUsingEncoding(NSUTF8StringEncoding)!
        var result = [CUnsignedChar](count: length, repeatedValue: 0)
        CCHmac(algorithm, cKey, Int(strlen(cKey)), cData, Int(strlen(cData)), &result)
        let data = NSData(bytes: result, length: length)
        let base64 = data.base64EncodedStringWithOptions([])
        return String(base64)
    }
}

func twitter(s: String) -> String {
    return "https://api.twitter.com/" + s
}

func authorizationOf(params: [String: AnyObject]) -> String {
    let parts: [String] = params
        .sort {
            (l, r) in l.0 <= r.0
        }
        .map {
            (k, v) in
            let ok = "\(v)"
            return "\(k.percentEncoded)=\"\(ok.percentEncoded)\""
        }
    let joined = parts.joinWithSeparator(", ")
    return "OAuth \(joined)"
}

func parameterString(params: [String: AnyObject]) -> String {
    return params
        .map {
            (a, b) in (a.percentEncoded, "\(b)".percentEncoded)
        }
        .sort {
            (l, r) in l.0 <= r.0
        }
        .map {
            (a, b) in "\(a)=\(b)"
        }
        .joinWithSeparator("&")
}

func baseString(params: [String: AnyObject], URL: String) -> String {
    return "POST&\(URL.percentEncoded)&\(parameterString(params).percentEncoded)"
}

class OAuthManager {
    init(mgr: Manager) {
        let env = NSProcessInfo.processInfo().environment
        self.consumerKey = env["CONSUMER_KEY"]!
        self.consumerSecret = env["CONSUMER_SECRET"]!
        self.accessToken = env["ACCESS_TOKEN"]!
        self.tokenSecret = env["TOKEN_SECRET"]!
        self.mgr = mgr
    }

    func go() {
        let URL = twitter("oauth/request_token")
        var oauth: [String: AnyObject] = [
            "oauth_callback": "oob",
            "oauth_consumer_key": consumerKey,
            "oauth_nonce": UInt(arc4random_uniform(UInt32.max)),
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": floor(NSDate().timeIntervalSince1970),
            "oauth_token": accessToken,
            "oauth_version": "1.0",
        ]
        oauth["oauth_signature"] = baseString(oauth, URL: URL).HMACSHA1(signingKey)

        mgr
            .request(.POST, twitter("oauth/request_token"), headers: ["authorization": authorizationOf(oauth)])
            .responseString { (response) -> Void in
                print("\(response.result.value)")
            }
    }

    let mgr: Manager
    let consumerKey: String
    let consumerSecret: String
    let accessToken: String
    let tokenSecret: String
    var state = OAuthState.Asleep

    var signingKey: String {
        return "\(consumerSecret)&\(tokenSecret)"
    }
}