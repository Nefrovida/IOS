import Foundation

struct RetroErrorMapper {
    static func map(_ error: Error) -> String {
        let nsError = error as NSError
        
        // Mensajes amigables y claros para el usuario
        let title = "¡UPS! ALGO SALIÓ MAL"
        var message = "Ocurrió un error inesperado."
        var suggestion = "Por favor, inténtalo de nuevo más tarde."
        
        // Detección básica de errores de red
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                message = "No tienes conexión a internet."
                suggestion = "Verifica tu wifi o datos móviles."
            case NSURLErrorTimedOut:
                message = "La conexión tardó demasiado."
                suggestion = "Tu internet parece lento, intenta de nuevo."
            case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                message = "No pudimos contactar al servidor."
                suggestion = "Es posible que estemos en mantenimiento."
            default:
                message = "Hubo un problema de conexión."
                suggestion = "Verifica tu red e intenta nuevamente."
            }
        }
        
        // Formato retro pero legible
        return """
        >>> \(title) <<<
        ----------------------------------
        \(message)
        
        \(suggestion)
        ----------------------------------
        (Código de error: \(nsError.code))
        """
    }
}
