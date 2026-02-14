import StoreKit
import Observation

@Observable
class StoreManager {
    private(set) var products: [Product] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    static let productIDs: Set<String> = [
        "tip_coffee",
        "tip_beer",
        "tip_champagne"
    ]

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let storeProducts = try await Product.products(for: Self.productIDs)
            // Sort by price ascending
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            errorMessage = "Da hat etwas nicht geklappt. Probier's später nochmal – der Goldfisch wartet. 🐟"
        }

        isLoading = false
    }

    /// Attempts to purchase a product. Returns true on success, false on cancellation/failure.
    func purchase(_ product: Product) async -> Bool {
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    return true
                case .unverified:
                    errorMessage = "Da hat etwas nicht geklappt. Probier's später nochmal – der Goldfisch wartet. 🐟"
                    return false
                }
            case .userCancelled:
                return false
            case .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            errorMessage = "Da hat etwas nicht geklappt. Probier's später nochmal – der Goldfisch wartet. 🐟"
            return false
        }
    }

    /// Returns the product for a given ID, or nil if not loaded
    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }

    /// Formatted price for a product ID, with fallback
    func displayPrice(for id: String, fallback: String) -> String {
        product(for: id)?.displayPrice ?? fallback
    }
}
