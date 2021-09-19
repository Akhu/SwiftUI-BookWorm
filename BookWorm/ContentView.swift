//
//  ContentView.swift
//  BookWorm
//
//  Created by Anthony Da cruz on 13/09/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true), NSSortDescriptor(keyPath: \Book.author, ascending: true)]) var books: FetchedResults<Book>

    @State private var isAddBookSheetShown: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self){ book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            book.rating != 1 ? Text(book.title ?? "Unknown Title")
                                .font(.headline) : Text(book.title ?? "Unknown Title")
                                .font(.headline).foregroundColor(.red)
                            
                            
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }.onDelete(perform: deleteBooks)
            }
            
            .navigationTitle(Text("BookWorm"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.isAddBookSheetShown.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                

            }
        }
        .sheet(isPresented: $isAddBookSheetShown, content: {
            AddBookView().environment(\.managedObjectContext, self.moc)
        })
        
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
