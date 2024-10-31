import SwiftUI

struct ContentView: View {
    
    @AppStorage("firstLaunch") var firstLaunch = true
    @State var showSplash = true
    
    var body: some View {
        if showSplash {
            Splash(showSplash: $showSplash, dataC: ViewModelFactory.shared.dataC)
        } else {
            if firstLaunch {
                CreateAccountView(viewModel: ViewModelFactory.shared.makeCreateAcccountViewModel(), show: $firstLaunch)
            } else {
                Tab()
            }
        }
    }
}

#Preview {
    ContentView()
}
