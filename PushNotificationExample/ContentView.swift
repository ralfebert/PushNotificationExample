import SwiftUI

struct ContentView: View {

    @EnvironmentObject var systemServices: ExampleAppSystemServices

    var body: some View {
        Text("Device Token: \(systemServices.pushNotificationDeviceToken ?? "-")")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
