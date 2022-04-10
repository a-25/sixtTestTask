enum InnerCleanliness: String {
    case regular = "REGULAR"
    case clean = "CLEAN"
    case veryClean = "VERY_CLEAN"
}

extension InnerCleanliness: Codable {}
