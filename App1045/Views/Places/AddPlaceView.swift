import SwiftUI

struct AddPlaceView: View {
    
    @Binding var show: Bool
    @ObservedObject var viewModel = ViewModelFactory.shared.makeAddPlaceViewModel()
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                ZStack {
                    Text("New places skiing")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                }
                VStack(spacing: 15) {
                    name
                    availability
                    rate
                    location
                    Button {
                        viewModel.addPressed()
                        show = false
                    } label: {
                        Text("Add")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(height: 40)
                            .background(Color.cPrimary)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .disabled(viewModel.disabled)
                    .opacity(viewModel.disabled ? 0.6 : 1)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var name: some View {
        VStack(spacing: 9) {
            Text("Name")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.name, needPrefix: false, prefix: "prefix", placeholder: "Enter place name")
        }
    }
    
    private var location: some View {
        VStack(spacing: 9) {
            Text("Location")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.location, needPrefix: false, prefix: "prefix", placeholder: "Enter location")
        }
    }
    
    private var availability: some View {
        HStack(spacing: 10) {
            Text("Availability")
                .font(.body.weight(.medium))
                .foregroundColor(.white)
            Text("Paid")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(width: 104, height: 50)
                .background(Color.c1972073)
                .clipShape(.rect(cornerRadius: 12))
                .opacity(!viewModel.available ? 1 : 0.3)
                .onTapGesture {
                    viewModel.available = false
                }
            Text("Free")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.black.opacity(0.7))
                .frame(width: 104, height: 50)
                .background(Color.cSecondary)
                .clipShape(.rect(cornerRadius: 12))
                .opacity(viewModel.available ? 1 : 0.3)
                .onTapGesture {
                    viewModel.available = true
                }
        }
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var rate: some View {
        HStack(spacing: 12) {
            Text("Rate")
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: viewModel.rate >= 1 ? "star.fill" : "star")
                .font(.body.weight(.regular))
                .foregroundColor(viewModel.rate >= 1 ? Color.cSecondary : .c241249245.opacity(0.5))
                .frame(width: 40, height: 40)
                .background(Color.c241249245.opacity(0.08))
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.c241249245.opacity(0.12), lineWidth: 0.33))
                .onTapGesture {
                    viewModel.rate = 1
                }
            Image(systemName: viewModel.rate >= 2 ? "star.fill" : "star")
                .font(.body.weight(.regular))
                .foregroundColor(viewModel.rate >= 2 ? Color.cSecondary : .c241249245.opacity(0.5))
                .frame(width: 40, height: 40)
                .background(Color.c241249245.opacity(0.08))
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.c241249245.opacity(0.12), lineWidth: 0.33))
                .onTapGesture {
                    viewModel.rate = 2
                }
            Image(systemName: viewModel.rate >= 3 ? "star.fill" : "star")
                .font(.body.weight(.regular))
                .foregroundColor(viewModel.rate >= 3 ? Color.cSecondary : .c241249245.opacity(0.5))
                .frame(width: 40, height: 40)
                .background(Color.c241249245.opacity(0.08))
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.c241249245.opacity(0.12), lineWidth: 0.33))
                .onTapGesture {
                    viewModel.rate = 3
                }
            Image(systemName: viewModel.rate >= 4 ? "star.fill" : "star")
                .font(.body.weight(.regular))
                .foregroundColor(viewModel.rate >= 4 ? Color.cSecondary : .c241249245.opacity(0.5))
                .frame(width: 40, height: 40)
                .background(Color.c241249245.opacity(0.08))
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.c241249245.opacity(0.12), lineWidth: 0.33))
                .onTapGesture {
                    viewModel.rate = 4
                }
            Image(systemName: viewModel.rate >= 5 ? "star.fill" : "star")
                .font(.body.weight(.regular))
                .foregroundColor(viewModel.rate >= 5 ? Color.cSecondary : .c241249245.opacity(0.5))
                .frame(width: 40, height: 40)
                .background(Color.c241249245.opacity(0.08))
                .clipShape(.circle)
                .overlay(Circle().stroke(Color.c241249245.opacity(0.12), lineWidth: 0.33))
                .onTapGesture {
                    viewModel.rate = 5
                }
        }
    }
}

struct AddPlaceView_Preview: PreviewProvider {
    
    @State static var show = true
    
    static var previews: some View {
        AddPlaceView(show: $show)
    }
}

final class AddPlaceViewModel: ObservableObject {
    
    let dataC: DataC
    
    var disabled: Bool {
        name == "" || rate == 0 || location == ""
    }
    
    @Published var name = ""
    @Published var available = false
    @Published var rate: Int = 0
    @Published var location = ""
    
    init(dataC: DataC) {
        self.dataC = dataC
    }
    
    func addPressed() {
        let place = Place(name: name, available: available, rate: rate, location: location)
        dataC.addPlace(place)
    }
}
