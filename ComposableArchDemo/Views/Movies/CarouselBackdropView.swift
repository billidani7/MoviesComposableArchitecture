//
//  DiscoverCarouselBackdrop.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 9/5/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarouselBackdropView: View {

    var movies: [Movie]
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                
                ForEach(movies){ movie in
                    CarouselBackdropItemView(movie: movie)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 18)
            .frame(height: 230)
            
        }
    }
}



struct CarouselBackdropItemView: View {
    var movie: Movie
    
    @State var showDetails: Bool = false
    
    var body: some View {
        ZStack {
            
            WebImage(url: movie.backdropURL)
            //movie.backdropImage?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 293, height: 165, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .blur(radius: 10)
                .offset(y: 18)
            
            
            WebImage(url: movie.backdropURL)
            //movie.backdropImage?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 320, height: 180, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            
            
            LinearGradient(gradient: Gradient(colors: [.clear, Color.black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .frame(height: 60) //100
                .offset(y: 60) //39
            
            
            
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                HStack() {
                    
                    Text(movie.finalTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)
                    
                    Spacer()
                }
                .padding()
            }
            
            
            
            
            
            
        }
        .frame(width: 320, height: 180)
    }
}


struct DiscoverCarouselBackdrop_Previews: PreviewProvider {
    static var previews: some View {
        CarouselBackdropView(movies: [sampleMovie, sampleMovie])
    }
}
