import SwiftUI

struct EditIncomeView: View {
    
    @ObservedObject var viewModel = ViewModelFactory.shared.makeEditIncomeViewModel()
    
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                Text("Edit income")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                Divider()
                VStack(spacing: 20) {
                    VStack(spacing: 9) {
                        Text("Income")
                            .font(.subheadline.weight(.regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        CustomTF(text: $viewModel.income, needPrefix: false, prefix: "prefix", placeholder: "Enter amount")
                            .onChange(of: viewModel.income, perform: { newValue in
                                validation(newValue)
                            })
                            .keyboardType(.numberPad)
                            
                    }
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
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    func validation(_ newValue: String) {
        var filtered = newValue.filter { Set("0123456789").contains($0) }
        while filtered != "" && filtered.first == "0" && filtered.count > 1 {
            filtered.removeFirst()
        }
        if filtered != "" {
            if let int = Int(filtered) {
                let ns = NSNumber(value: int)
                let formatter = NumberFormatter()
                formatter.groupingSeparator = " "
                formatter.groupingSize = 3
                formatter.numberStyle = .decimal
                let str = String((formatter.string(from: ns) ?? filtered))
                viewModel.income = "$" + str
            } else {
                viewModel.income = "$" + filtered
            }
        } else {
            viewModel.income = ""
        }
    }
}

struct EditIncomeView_Preview: PreviewProvider {
    
    @State static var income = ""
    @State static var show = true
    
    static var previews: some View {
        EditIncomeView(show: $show)
    }
    
}

final class EditIncomeViewModel: ObservableObject {
    
    let dataC: DataC
    @Published var income = ""
    var disabled: Bool {
        income == ""
    }
    
    init(dataC: DataC) {
        self.dataC = dataC
    }
    
    func addPressed() {
        income.removeFirst()
        guard let value = Int(income) else { return }
        dataC.saveIncome(value)
    }
}
