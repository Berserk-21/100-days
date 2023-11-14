import UIKit

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
    // Capitalized first letter
    var capitalizedString: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
    
    // Contains any String of an array
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
    
    // Challenge 1
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        } else {
            return prefix + self
        }
    }
    
    // Challenge 2
    func isNumeric() -> Bool {
        
        for character in self {
            if character.isNumber {
                return true
            }
        }
        
        return false
    }
    
    // Challenge 3
    func linesToArray() -> [String] {
        var array: [String] = []
        
        let components = self.components(separatedBy: "\n")
        for component in components {
            array.append(component)
        }
        
        return array
    }
}

let name = "Taylor"

for letter in name {
    print("Here is: \(letter)")
}

// Subscript, find a character in a String with an index
let fourthLetter = name[name.index(name.startIndex, offsetBy: 0)]
name[4]

// Remove certain characters in a String
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

let newPwrd = password.deletingPrefix("123")
let dropLastPwrd = password.deletingSuffix("45")

// Capitalize
let weather = "it's going to rain"
weather.capitalized
weather.capitalizedString

// Contains
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")
input.containsAny(of: languages)

languages.contains { string in
    return input.contains(string)
}
languages.contains(where: input.contains)

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36.0)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let mutableAttributedString = NSMutableAttributedString(string: string)
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

// Challenge 1
let pet = "pet"
let car = "car"

let carpet = pet.withPrefix(car)
carpet.withPrefix(car)

// Challenge 2
let myString = "Bad Boys 2"
myString.isNumeric()

// Challenge 3
let superString = "this\nis\na\ntest"
let arrayFromString = superString.linesToArray()

