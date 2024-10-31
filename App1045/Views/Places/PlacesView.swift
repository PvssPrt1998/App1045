import SwiftUI
import Combine

struct PlacesView: View {
    
    @ObservedObject var viewModel = ViewModelFactory.shared.makePlacesViewModel()
    @State var newPlace = false
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                header
                
                if viewModel.places.isEmpty {
                    emptyPlaces
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.places, id: \.self) { place in
                                placeCard(place)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.top, 32)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $newPlace, content: {
            AddPlaceView(show: $newPlace)
        })
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("Places for skiing")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 8, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .leading)
            if !viewModel.places.isEmpty {
                Button {
                    newPlace = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private var emptyPlaces: some View {
        VStack {
            VStack(spacing: 5) {
                Text("Create new places\nskiing")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Here you can leave places for\nskiing both paid and free")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white.opacity(0.3))
                    .multilineTextAlignment(.center)
                Button {
                    newPlace = true
                } label: {
                    Text("Click to create")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 228, height: 40)
                        .background(Color.cPrimary)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    private func placeCard(_ place: Place) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                if !place.available {
                    Text("Paid")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(.c11510)
                        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .background(Color.c1972073)
                        .clipShape(.rect(cornerRadius: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("It's free")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(.c11510)
                        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .background(Color.cSecondary)
                        .clipShape(.rect(cornerRadius: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: place.rate >= 1 ? "star.fill" : "star")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(place.rate >= 1 ? .cSecondary : .c241249245.opacity(0.5))
                    Image(systemName: place.rate >= 2 ? "star.fill" : "star")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(place.rate >= 2 ? .cSecondary : .c241249245.opacity(0.5))
                    Image(systemName: place.rate >= 3 ? "star.fill" : "star")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(place.rate >= 3 ? .cSecondary : .c241249245.opacity(0.5))
                    Image(systemName: place.rate >= 4 ? "star.fill" : "star")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(place.rate >= 4 ? .cSecondary : .c241249245.opacity(0.5))
                    Image(systemName: place.rate >= 5 ? "star.fill" : "star")
                        .font(.subheadline.weight(.regular))
                        .foregroundColor(place.rate >= 5 ? .cSecondary : .c241249245.opacity(0.5))
                }
                .padding(.horizontal, 8)
                .frame(height: 32)
                .background(Color.c241249245.opacity(0.08))
                .clipShape(.rect(cornerRadius: 12))
            }
            
            VStack(spacing: 5) {
                Text(place.name)
                    .font(.callout.weight(.regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 5) {
                    Text("Location")
                        .font(.footnote.weight(.regular))
                        .foregroundColor(.c147151159)
                    Text(place.location)
                        .font(.footnote.weight(.regular))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(10)
        .background(Color.cPrimary)
        .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    PlacesView()
}

final class PlacesViewModel: ObservableObject {
    
    let dataC: DataC
    
    @Published var places: Array<Place>
    
    private var placesCancellable: AnyCancellable?
    
    init(dataC: DataC) {
        self.dataC = dataC
        self.places = dataC.places
        
        placesCancellable = dataC.$places.sink { [weak self] value in
            self?.places = value
        }
    }
}
