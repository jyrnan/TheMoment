//
//  CommitRowView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct CommitRowView: View {
    let leftSpace: CGFloat = Dim.leftSpace
    let lineWidth: CGFloat = Dim.lineWidth
    let iconRadius: CGFloat = 6
    let rightSpace: CGFloat = 16
    
    let edgeSpacing: CGFloat = 16
    let textSpacing: CGFloat = 8
    let contentSpacing: CGFloat = 4
    
    let boardColor: Color = .red
    
    var shouldDisplayDate: Bool {Bool.random()}

    var commit: Commit
    
    var icon: some View {Circle()}

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                icon
                    .foregroundColor(.accentColor)
                    .frame(width: iconRadius * 2 , height: iconRadius * 2)
                    .padding(.leading, leftSpace + lineWidth / 2 - iconRadius)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
                    .border(boardColor)
                
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: 2)
                    .padding(.leading, leftSpace)
                    .padding(.trailing, rightSpace)
                    .border(boardColor)
                
            }
            .frame(width: leftSpace + lineWidth + rightSpace)
            .border(boardColor)

            VStack(spacing: 0) {
                Color.clear
                    .frame(height: 16)
                
                HStack{
                    if shouldDisplayDate {
                        Text(commit.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption.bold())
                            .foregroundColor(.init(uiColor: .systemBackground))
                            .padding(contentSpacing)
                            .background(Capsule().foregroundColor(.gray))
                            .frame(minHeight: 24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.border(boardColor)
                
                HStack{
                    Text("Location View")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                        .padding(.top, textSpacing)
                        .padding(.leading, textSpacing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.border(boardColor)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        if commit.title != nil {
                            Text("\(commit.title!)").padding(textSpacing)
                                .font(.body.bold())
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture { print("\(commit.title!)") }
                                .border(boardColor)
                        }
                        
                        if commit.content != nil {
                            Text("\(commit.content!)").padding(textSpacing)
                                .lineLimit(5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .border(boardColor)
                        }
                    }
//                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if commit.images.count != 0 && commit.content != nil {
                        ZStack {
                            Image("Image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .layoutPriority(-1)
                            Color.clear
                                .frame(width: 64, height: 64)
                        }
                        .clipped()
                        .aspectRatio(1, contentMode: .fit).cornerRadius(4)
                        .padding(textSpacing)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                
                if commit.images.count != 0 && commit.content == nil {
                    ZStack {
                        Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .layoutPriority(-1)
                        Color.clear
                            .frame(maxWidth: .infinity)
                    }
                    .clipped()
                    .aspectRatio(16 / 9, contentMode: .fill).cornerRadius(8)
                    .padding(textSpacing)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                }
                

                HStack(spacing: 0){
                    Text(commit.weather)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.leading, textSpacing)
                        .border(boardColor)
                    
                    Spacer()
                    
                    Text(commit.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.trailing, textSpacing)
                        .border(boardColor)
                }
            }
            .border(boardColor)
        }
        .border(boardColor)
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommitRowView(commit: Commit.examples.first!)
        CommitRowView(commit: Commit.examples[1])
        CommitRowView(commit: Commit.examples[2])
    }
}
