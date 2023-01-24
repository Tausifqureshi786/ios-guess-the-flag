//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tausif Qureshi on 2022-10-26.
//

/*
 Go back to project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.

 */

import SwiftUI


// Day 24: Challenge #2
struct FlagImage:  View {
    
    var countryFlag: String
    
    var body: some View {
        Image(countryFlag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}


// Day 24: Challenge #3
struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle)
    }
}

extension View {
    func appliedBlueTitle() -> some View {
        modifier(BlueTitle())
    }
}


struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionNumber = 1
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3) ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.title.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Spacer()
                        Text("Question \(questionNumber) of 8")
                            .appliedBlueTitle()
                        Spacer()
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        Spacer()
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(countryFlag: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            
            Button( questionNumber < 8 ? "Continue" : "Restart Game" , role: questionNumber == 8 ? .destructive : .none , action: questionNumber < 8 ? askQuestion : restartGame)
            
            
        } message: {
            if questionNumber < 8 {
                Text("Your score is \(score)")
            } else {
                Text("Your total score is \(score). \n Restart the game by pressing the button below.")
            }
        }
    }
    
    func restartGame () {
        questionNumber = 1
        countries.shuffle()
        score = 0
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct Answer"
            score += 1
        } else {
            scoreTitle = "Wrong Answer. \n That's the flag of \(countries[number])."
        }
        showingScore = true
    }
    
    func askQuestion () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNumber += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
