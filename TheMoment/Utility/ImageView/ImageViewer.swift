//
//  ImageViewer.swift
//  FetchMeeBySwiftUI
//
//  Created by yoeking on 2020/7/12.
//  Copyright © 2020 jyrnan. All rights reserved.
//

import SwiftUI

struct ImageViewer: View {
  @Environment(\.dismiss) var dismiss
  var image: UIImage
    
  @State var currentScale: CGFloat = 1.0
  @State var previousScale: CGFloat = 1.0
    
  @State var currentOffset = CGSize.zero
  @State var previousOffset = CGSize.zero
    
  @State var pointTapped: CGPoint = .zero
    
  @State var opacity: CGFloat = 1.0
    
  private var imageView: some View {
    Image(uiImage: image)
      .resizable()
      .scaledToFit()
      .offset(x: self.currentOffset.width, y: self.currentOffset.height)
      .scaleEffect(max(self.currentScale, 1.0), anchor: .center)
        
      .gesture(TapGesture(count: 2)
        .onEnded {
          if self.currentScale != 1 {
            withAnimation {
              self.currentScale = 1
              currentOffset = CGSize.zero
            }
          } else {
            withAnimation { self.currentScale = 3 }
          }
        })
        
      .gesture(TapGesture(count: 1)
        .onEnded {
          guard currentScale == 1.0 else { return }
          dismiss()
        })
        
      .gesture(LongPressGesture()
        .onEnded { _ in
                
        })
      .gesture(DragGesture()
        .onChanged { value in
          guard currentScale != 1 else {
            guard value.translation.height < 150 else {
              withAnimation { opacity = 0 }
              dismiss()
              return
            }
                    
            // 更改图片查看背景透明度
            let halfHeight = UIScreen.main.bounds.height / 1
            let progress = value.translation.height / halfHeight
            withAnimation { opacity = 1 - progress }
                    
            self.pointTapped = value.startLocation
                    
            let deltaY = value.translation.height - self.previousOffset.height
                    
            self.previousOffset.width = value.translation.width
            self.previousOffset.height = value.translation.height
                    
            self.currentOffset.height = self.currentOffset.height + deltaY / self.currentScale
            return
          }
                
          self.pointTapped = value.startLocation
                
          let deltaX = value.translation.width - self.previousOffset.width
          let deltaY = value.translation.height - self.previousOffset.height
          self.previousOffset.width = value.translation.width
          self.previousOffset.height = value.translation.height
                
          self.currentOffset.width = self.currentOffset.width + deltaX / self.currentScale
          self.currentOffset.height = self.currentOffset.height + deltaY / self.currentScale
        }
        .onEnded { _ in
          guard currentScale != 1 else {
            withAnimation {
              opacity = 1
              self.currentOffset = .zero
            }
            self.previousOffset = CGSize.zero
            return
          }
          self.previousOffset = CGSize.zero
        }
      )
        
      .gesture(MagnificationGesture()
        .onChanged { value in
          let delta = value / self.previousScale
          self.previousScale = value
          self.currentScale = self.currentScale * delta < 1 ? 1 : self.currentScale * delta
        }
        .onEnded { _ in self.previousScale = 1.0 }
      )
  }
    
  private var closeButton: some View {
    VStack {
      Spacer()
      Button(action: { dismiss() },
             label: {
               Text("Close").opacity(currentScale == 1 ? 1.0 : 0)
             })
             .tint(.accentColor)
    }
  }
    
  var body: some View {
    ZStack {
      imageView
    }
  }
}

struct ImageViewer_Previews: PreviewProvider {
  static var previews: some View {
    ImageViewer(image: UIImage(named: "defaultImage")!)
  }
}
