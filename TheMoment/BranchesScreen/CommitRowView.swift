//
//  CommitRowView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI
import CoreData

struct CommitRowView: View {
    let leftSpace: CGFloat = Dim.leftSpace
    let lineWidth: CGFloat = Dim.lineWidth
    let iconRadius: CGFloat = 12
    let dotRadius: CGFloat = 4
    let rightSpace: CGFloat = Dim.rightSpace
    
    let edgeSpacing: CGFloat = 16
    let textSpacing: CGFloat = 8
    let contentSpacing: CGFloat = 4
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var shouldShowBorder: Bool = false
    
    var boardColor: Color { shouldShowBorder ? .red : .clear }
    
    @State var shouldShowDate: Bool = .random()
    @State var dateViewHeight: CGFloat = DateViewHeight.defaultValue
    
    @State var rowHeight: CGFloat = RowHeight.defaultValue

    @ObservedObject var commit: CD_Commit
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                lineView
                if shouldShowDate { dotView }
                iconView
            }
            .frame(width: leftSpace + lineWidth + rightSpace) // , height: rowHeight)
            .border(boardColor)

            VStack(spacing: contentSpacing) {
                VStack(spacing: textSpacing) {
                    Color.clear
                        .frame(height: textSpacing)
                        .border(boardColor)
                    
                    if shouldShowDate { dateView.border(boardColor) }
                    
                    locationView.border(boardColor)
                }
                .readGeometry(\.size.height, key: IconTopSpacing.self)
                .onPreferenceChange(IconTopSpacing.self) {
                    iconTopSpacing = $0 + contentSpacing
                }
                .border(boardColor)
                
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: contentSpacing) {
                        if commit.title != nil { titleView }
//                        titleView
                        if commit.content != nil { contentView }
//                        contentView
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if commit.images?.count != 0, commit.content != nil {
                        imagesThumbView.padding(.leading, 4)
                    }
                }
                .border(boardColor)
                
                if commit.images?.count != 0, commit.content == nil {
                    imagesView
                }
                
                HStack(spacing: 0) {
                    weatherView
                    Spacer()
                    commitTimeView
                }
            }
            .padding(.horizontal, textSpacing)
            .readGeometry(\.size.height, key: RowHeight.self)
            .onPreferenceChange(RowHeight.self) {
                rowHeight = $0
            }
            .border(boardColor)
        }
        
        .border(boardColor)
    }
    
    // MARK: -  SubViews
    
    var dotTopSpacing: CGFloat { textSpacing + textSpacing + (dateViewHeight - dotRadius) / 2 }
    var dotView: some View {
        Circle()
            .foregroundColor(.accentColor)
            .frame(width: dotRadius * 2, height: dotRadius * 2)
            .padding(.leading, leftSpace + lineWidth / 2 - dotRadius)
            .padding(.top, dotTopSpacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .border(boardColor)
    }
    
    @State private var iconTopSpacing: CGFloat = IconTopSpacing.defaultValue
    func makeIcon(commit: CD_Commit) -> some View {
        if let emoji = commit.emoji { return Text(emoji).font(.callout) }
        if commit.images?.first != nil { return Text("\(Image(systemName: "photo.fill"))") }
        if commit.title != nil || commit.content != nil { return Text("\(Image(systemName: "message.fill"))") }
        return Text("\(Image(systemName: "mappin.and.ellipse"))")
    }

    var iconView: some View {
        Circle().fill(Color.accentColor.gradient)
            .overlay {
                makeIcon(commit: commit)
                    .font(.caption)
                    .foregroundColor(Color(.white))
            }
            .foregroundColor(.red)
            .frame(width: iconRadius * 2, height: iconRadius * 2)
            .padding(.leading, leftSpace + lineWidth / 2 - iconRadius)
            .padding(.top, iconTopSpacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .border(boardColor)
    }
    
    var lineView: some View {
        Rectangle()
            .foregroundColor(.accentColor)
            .frame(width: 2)
            .padding(.leading, leftSpace)
            .padding(.trailing, rightSpace)
            .border(boardColor)
    }
    
    var dateView: some View {
        Text(commit.date?.formatted(date: .abbreviated, time: .omitted) ?? ".now")
            .font(.caption.bold())
            .foregroundColor(.init(uiColor: .systemBackground))
            .padding(contentSpacing)
            .background(Capsule().fill(.gray.gradient))
            .frame(maxWidth: .infinity, alignment: .leading)
            .readGeometry(\.size.height, key: DateViewHeight.self)
            .onPreferenceChange(DateViewHeight.self) { dateViewHeight = $0 }
    }
    
    var locationView: some View {
        HStack {
            Image(systemName: "location")
                .font(.caption)
                .foregroundColor(.gray)
            Text("22.54°N, 36.38°E")
                .font(.caption.bold())
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onTapGesture {
            shouldShowBorder.toggle()
        }
    }
    
    var titleView: some View {
        Text(commit.title ?? "")
            .font(.body.bold())
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                print("\(commit.title!)")
                shouldShowBorder.toggle()
//                commit.cd_commit(context: viewContext)
            }
            .border(boardColor)
    }
    
    var contentView: some View {
        Text(commit.content ?? "").font(.callout)
            .lineLimit(5)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .border(boardColor)
    }
    
    var imagesThumbView: some View {
        ZStack {
            Image(uiImage: commit.firstThumbnail)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .layoutPriority(-1)
            
            Color.clear
                .frame(width: 64, height: 64)
        }
        .clipped()
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(8)
//        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    var imagesView: some View {
        ZStack {
            TabView {
                ForEach(commit.thumbnailsArray, id: \.id) { thumbnail in
                    Image(uiImage: UIImage(data:thumbnail.data!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .tabViewStyle(.page)
            .layoutPriority(-1)
            
            Color.clear
                .frame(height: 200)
                .frame(maxWidth: .infinity)
        }
        .clipped()
        .aspectRatio(contentMode: .fill)
        .cornerRadius(16)
        .border(boardColor)
    }
    
    var weatherView: some View {
        Text("\(Image(systemName: "sun.max")) \(commit.weather ?? "") \(arc4random_uniform(25))°C")
            
            .font(.caption2)
            .foregroundColor(.gray)
            .border(boardColor)
    }
    
    var commitTimeView: some View {
        Text(commit.date?.formatted(date: .abbreviated, time: .shortened) ?? ".now")
            .font(.caption2)
            .foregroundColor(.gray)
            .border(boardColor)
    }
}

struct PostRowView_Previews: PreviewProvider {
    static let viewContext = PersistenceController.shared.container.viewContext
    static var previews: some View {
        CommitRowView(commit: CD_Commit.new(context: viewContext))
        CommitRowView(commit: CD_Commit.noTitle(context: viewContext))
    }
}

extension CommitRowView {
    struct IconTopSpacing: PreferenceKey {
        static var defaultValue: CGFloat = 64
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct DateViewHeight: PreferenceKey {
        static var defaultValue: CGFloat = 24
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct TitleViewHeight: PreferenceKey {
        static var defaultValue: CGFloat = 24
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct RowHeight: PreferenceKey {
        static var defaultValue: CGFloat = 60
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

