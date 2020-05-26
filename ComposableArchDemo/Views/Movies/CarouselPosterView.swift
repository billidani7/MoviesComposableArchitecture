//
//  CarouselPosterView.swift
//  MoviesDemo
//
//  Created by Vasilis Daningelis on 25/4/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CarouselPosterView: View {
    var movies: [Movie]
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                
                ForEach(movies){ movie in
                    
                    MovieItemList( movie: movie, posterSize: CGSize(width: 140, height: 210))
                    
                }
            }
            .frame(height: 210 + 30)
            .padding(.leading, 15)
            .padding(.bottom, 5)
            
        }
    }
}


struct MovieItemList: View {

    var movie: Movie

    var posterSize =  CGSize(width: 158, height: 227)
    
    @State var showMovieDetails: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack {
                WebImage(url: movie.posterURL) //Blur effect
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: posterSize.width - 18, height: posterSize.height - 26, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .blur(radius: 10)
                   
                
                Spacer()
            }
            .frame(width: posterSize.width, height: posterSize.height)
            .offset(y: 20)
            
            
            VStack {
                WebImage(url: movie.posterURL) //Actual Image above blur effect
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade) // Fade Transition
                    .scaledToFit()
                    
                    .aspectRatio(contentMode: .fill)
                    .frame(width: posterSize.width, height: posterSize.height, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        
                Text(movie.finalTitle.uppercased())
                    .foregroundColor(Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)))
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: posterSize.width)
                
            }

        }

    }
}

struct CarouselPosterView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPosterView(movies: [sampleMovie, sampleMovie, sampleMovie])
    }
}
