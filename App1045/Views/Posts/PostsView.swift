import SwiftUI
import Combine

struct PostsView: View {
    @ObservedObject var viewModel = ViewModelFactory.shared.makePostsViewModel()
    @State var newPost = false
    @State var postDetail = false
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                header
                
                if viewModel.posts.isEmpty {
                    emptyPosts
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.posts, id: \.self) { post in
                                postCard(post)
                                    .onTapGesture {
                                        viewModel.postForShow = post
                                        postDetail = true
                                    }
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
        .sheet(isPresented: $newPost, content: {
            NewPost(show: $newPost)
        })
        .sheet(isPresented: $postDetail, content: {
            PostDetail(viewModel: ViewModelFactory.shared.makePostDetailViewModel(viewModel.postForShow!), show: $postDetail)
        })
    }
    
    private func postCard(_ post: Post) -> some View {
        VStack(spacing: 10) {
            Text(post.date)
                .font(.caption)
                .foregroundColor(.c147151159)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(post.name)
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(post.description)
                .font(.caption)
                .foregroundColor(.c147151159)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Color.cPrimary)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    private var emptyPosts: some View {
        VStack {
            VStack(spacing: 5) {
                Text("Create your first post")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Write posts about your\nachievements or interesting facts")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white.opacity(0.3))
                    .multilineTextAlignment(.center)
                Button {
                    newPost = true
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
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("My posts")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 8, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .leading)
            if !viewModel.posts.isEmpty {
                Button {
                    newPost = true
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
}

#Preview {
    PostsView()
}

final class PostsViewModel: ObservableObject {
    
    let dataC: DataC
    
    @Published var posts: Array<Post>
    
    var postForShow: Post?
    
    private var postsCancellable: AnyCancellable?
    
    init(dataC: DataC) {
        self.dataC = dataC
        self.posts = dataC.posts
        
        postsCancellable = dataC.$posts.sink { [weak self] value in
            self?.posts = value
        }
    }
    
    
    
}
