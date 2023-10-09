import Foundation
import PBXProj
import XCScheme

// FIXME: Extract to function struct
extension Dictionary where Key == TargetID, Value == [BuildableReference] {
    static func parseTransitivePreviewReferences(
        from url: URL?,
        targetsByID: [TargetID: Target]
    ) async throws -> Self {
        guard let url = url else {
            return [:]
        }

        var rawArgs = ArraySlice(try await url.lines.collect())

        var keysWithValues: [(TargetID, [BuildableReference])] = []
        while !rawArgs.isEmpty {
            let id = try rawArgs.consumeArg(TargetID.self, in: url)
            let buildableReferences = try rawArgs.consumeArgs(
                BuildableReference.self,
                in: url,
                transform: { id in
                     try targetsByID
                        .value(
                            for: TargetID(id),
                            context: "Additional target"
                        )
                        .buildableReference
                }
            )
            keysWithValues.append((id, buildableReferences))
        }

        return Dictionary(uniqueKeysWithValues: keysWithValues)
    }
}
