import SwiftUI
import Combine

struct PostDetail: View {
    
    @ObservedObject var viewModel: PostDetailViewModel
    @Binding var show: Bool
    @State var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.c606067.opacity(0.3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 5)
                    header
                        VStack(spacing: 0) {
                            Text(viewModel.post.date)
                                .font(.caption.weight(.regular))
                                .foregroundColor(.c147151159)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text(viewModel.post.name)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 10) {
                                Text("Description")
                                    .font(.subheadline.weight(.regular))
                                    .foregroundColor(.white.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                ScrollView(.vertical, showsIndicators: false) {
                                    Text(viewModel.post.description)
                                        .font(.subheadline.weight(.regular))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 16)
                                }
                            }
                            .padding(.vertical, 10)
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                    
                    
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private var header: some View {
        ZStack {
            Text("My posts")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 15)
            HStack {
                Button {
                    show = false
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.cSecondary)
                        
                        Text("Back")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.cSecondary)
                    }
                    .padding(.horizontal, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                HStack(spacing: 16) {
                    NavigationLink {
                        EditPost(viewModel: ViewModelFactory.shared.makeEditPostViewModel(viewModel.post))
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.cSecondary)
                    }
                    Button {
                        withAnimation {
                            showDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 22)
                            .foregroundColor(.cSecondary)
                        .padding(.trailing, 16)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .default(Text("Delete"), action: {
                            viewModel.delete()
                            show = false
                        }), secondaryButton: .destructive(Text("Close")))
                    }
                }
            }
        }
    }
}

struct PostDetail_Preview: PreviewProvider {
    
    @State static var show: Bool = true
    
    static var previews: some View {
        PostDetail(viewModel: ViewModelFactory.shared.makePostDetailViewModel(Post(uuid: UUID(), name: "Name", date: "05.12.22", description: "Description")), show: $show)
    }
}

final class PostDetailViewModel: ObservableObject {
    
    let dataC: DataC
    var post: Post
    
    private var postsCancellable: AnyCancellable?
    
    init(dataC: DataC, post: Post) {
        self.dataC = dataC
        self.post = post
        
        postsCancellable = dataC.$posts.sink { [weak self] value in
            guard let index = value.firstIndex(where: {$0.uuid == post.uuid}) else { return }
            self?.post = value[index]
            self?.objectWillChange.send()
        }
    }
    
    func delete() {
        dataC.delete(post)
    }
}
