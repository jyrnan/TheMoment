//
//  BannerView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/4.
//

import SwiftUI

struct BannerView: View {
    var body: some View {
        Image("Banner")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: UIScreen.main.bounds.size.width,
                height: 240)
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
