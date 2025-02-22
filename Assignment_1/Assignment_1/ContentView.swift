import SwiftUI

struct ContentView: View {
    @State private var number = Int.random(in: 1...100)
    @State private var isCorrect: Bool? = nil
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attempts = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Is this number prime?")
                .font(.largeTitle)
                .bold()
            
            Text("(number)")
                .font(.system(size: 80, weight: .bold))
                .padding()
            
            HStack {
                Button("Prime") {
                    checkAnswer(isPrime: true)
                }
                .buttonStyle(CustomButtonStyle(color: .blue))
                
                Button("Not Prime") {
                    checkAnswer(isPrime: false)
                }
                .buttonStyle(CustomButtonStyle(color: .red))
            }
        }
    func checkAnswer(isPrime: Bool) {
            if isPrime == isNumberPrime(number) {
                correctCount += 1
                isCorrect = true
            } else {
                wrongCount += 1
                isCorrect = false
            }

            attempts += 1
        }
    func isNumberPrime( num: Int) -> Bool {
        if num < 2 { return false }
        for i in 2..<num {
            if num % i == 0 {
                return false
            }
        }
        return true
    }
}
    
struct CustomButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 150)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

