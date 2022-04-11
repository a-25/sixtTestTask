enum CarColor: String {
    case midnightBlack = "midnight_black"
    case hotChocolate = "hot_chocolate"
    case midnightBlackMetal = "midnight_black_metal"
    case lightWhite = "light_white"
    case icedChocolate = "iced_chocolate"
    case alpinweiss = "alpinweiss"
    case saphirschwarz = "saphirschwarz"
    case schwarz = "schwarz"
    case absoluteBlackMetal = "absolute_black_metal"
}

extension CarColor: Codable {}

extension CarColor: Equatable {}
