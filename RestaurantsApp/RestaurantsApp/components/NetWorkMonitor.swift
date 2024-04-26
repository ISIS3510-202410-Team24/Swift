import Network
import SwiftUI



class NetworkMonitor : ObservableObject {
    let queue = DispatchQueue( label: "Network monitor queue" )
    let monitor = NWPathMonitor()
    @Published var isConnected = true
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start( queue: queue )
    }
}
