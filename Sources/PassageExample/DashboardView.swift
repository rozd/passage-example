import Passage

struct DashboardView: Sendable, Encodable {
    let theme: Passage.Views.Theme.Colors
    let params: Context
    
    public init(
        theme: Passage.Views.Theme.Colors,
        params: Context
    ) {
        self.theme = theme
        self.params = params
    }
    
    struct Context: Encodable {
        let email: String?
        let phone: String?
        let username: String?
        let userID: String
        let logoutRoute: String
        
        init(user: any User, logoutRoute: String) {
            self.email = user.email
            self.phone = user.phone
            self.username = user.username
            self.userID = user.id?.description ?? "Unknown UserID"
            self.logoutRoute = logoutRoute
        }
    }
}
