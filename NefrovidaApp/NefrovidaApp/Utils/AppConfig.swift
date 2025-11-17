import Foundation

public enum AppConfig {
    // Use `https://da73728646c1.ngrok-free.app/api` as the base URL (ngrok provided)
    public static let apiBaseURL = "https://da73728646c1.ngrok-free.app/api"

    // Toggle to `true` to hit the remote API. Default is false (use MockRepo)
    public static let useRemoteForums = true

    // For development, provide a token provider. This closure should return the current JWT or nil.
    // In production, replace with a secure Keychain-backed provider.
    public static var tokenProvider: () -> String? = {
        // Example: read token from UserDefaults (dev only)
        return UserDefaults.standard.string(forKey: "jwt_token")
    }
}
