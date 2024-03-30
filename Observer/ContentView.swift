import StarCraftKit
import SwiftUI

struct ContentView: View {
    
    @State private var tournaments: [Tournament] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tournaments.groupedByLeague(), id: \.league.name) { group in
                    DisclosureGroup {
                        ForEach(group.tournaments) { tournament in
                            VStack(alignment: .leading) {
                                Text(tournament.name)
                                    .font(.subheadline)
                                Text(tournament.beginAt.formatted(.relative(presentation: .named)))
                                    .font(.caption)
                            }
                        }
                    } label: {
                        Text(group.league.name)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Past events")
            .task(load)
        }
    }
    
    @Sendable private func load() async {
        do {
            tournaments = try await api.allTournaments().concludedTournaments
        } catch {
            print(error)
        }
    }
    
    private let api = StarCraftAPI(token: ProcessInfo.processInfo.environment["PANDA_TOKEN"]!)
}

#Preview {
    ContentView()
}
