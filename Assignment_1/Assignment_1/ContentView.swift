import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var number = Int.random(in: 1...100)
    @State private var isCorrect: Bool? = nil
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attempts = 0
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 30) {
            if gameStarted {
                Text("Is this number prime?")
                    .font(.largeTitle)
                    .bold()
                
                Text("\(number)")
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
                
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(isCorrect ? .green : .red)
                        .transition(.scale)
                }
            } else {
                VStack {
                    Text("Prime Number Game!")
                        .font(.title)
                        .padding()
                    
                    Button("Start Game") {
                        startGame()
                    }
                    .buttonStyle(CustomButtonStyle(color: .blue))
                }
            }
        }
        .onAppear {
            timer?.invalidate()
        }
        .alert("Game Over", isPresented: .constant(attempts >= 10)) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Correct: \(correctCount)\nWrong: \(wrongCount)")
        }
    }

    func startGame() {
        gameStarted = true
        attempts = 0
        correctCount = 0
        wrongCount = 0
        number = Int.random(in: 1...100)
        isCorrect = nil
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            handleTimeout()
        }
    }

    func checkAnswer(isPrime: Bool) {
        timer?.invalidate()
        
        if isPrime == isNumberPrime(number) {
            correctCount += 1
            isCorrect = true
        } else {
            wrongCount += 1
            isCorrect = false
        }

        attempts += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            nextNumber()
        }
    }

    func handleTimeout() {
        wrongCount += 1
        attempts += 1
        isCorrect = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            nextNumber()
        }
    }

    func nextNumber() {
        if attempts >= 10 {
            timer?.invalidate()
        } else {
            number = Int.random(in: 1...100)
            isCorrect = nil
            startTimer()
        }
    }

    func resetGame() {
        gameStarted = false
        timer?.invalidate()
    }

    func isNumberPrime(_ num: Int) -> Bool {
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
