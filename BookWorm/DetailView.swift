//
//  DetailView.swift
//  DetailView
//
//  Created by Anthony Da cruz on 19/09/2021.
//

import SwiftUI
import CoreData

struct DetailView: View {
    let book: Book
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State var showingDeleteAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 18) {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Default")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width, maxHeight: 250)
                    Text(self.book.genre ?? "Default")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                        .offset(x: -10, y: -10)
                }.clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Text(self.book.author ?? "Unkown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(self.book.createdAt?.formatted(
                    .dateTime
                    .month(.wide)
                    .day()
                    .year(.relatedGregorian()))
                        ?? "Unknown date")
                Text(self.book.review ?? "No review")
                RatingView(rating: .constant(Int(self.book.rating)))
                Spacer()
            }
        }
        .alert(isPresented: $showingDeleteAlert, content: {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
            }, secondaryButton: .cancel())
        })
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash.circle.fill")
                .foregroundColor(.red)
        })
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(book.title ?? "Unknown Book"))
    }
    
    func deleteBook() {
        moc.delete(book)
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Default"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        book.createdAt = Date()
        return NavigationView {
            DetailView(book: book)
        }
        .preferredColorScheme(.dark)
    }
}
