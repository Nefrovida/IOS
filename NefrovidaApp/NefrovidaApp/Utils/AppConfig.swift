import Foundation

public enum AppConfig {
    //public static let apiBaseURL = "https://www.snefrovidaac.com/api"
    public static let apiBaseURL = "http://10.25.72.88:3001/api"

    // Toggle to `true` to hit the remote API. Default is false (use MockRepo)
    public static let useRemoteForums = true

    // For development, provide a token provider. This closure should return the current JWT or nil.
    // In production, replace with a secure Keychain-backed provider.
    public static var tokenProvider: () -> String? = {
        // Example: read token from UserDefaults (dev only)
        return UserDefaults.standard.string(forKey: "jwt_token")
        //help again
    }
}
    
