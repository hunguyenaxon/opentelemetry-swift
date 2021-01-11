// Copyright 2020, OpenTelemetry Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import OpenTelemetryApi

public class BaggageSdk: Baggage, Equatable {
    // The types of the EntryKey and Entry must match for each entry.
    var entries: [EntryKey: Entry?]
    var parent: BaggageSdk?

    /// Creates a new BaggageSdk with the given entries.
    /// - Parameters:
    ///   - entries: the initial entries for this BaggageSdk
    ///   - parent: parent providing a default set of entries
    fileprivate init(entries: [EntryKey: Entry?], parent: BaggageSdk?) {
        self.entries = entries
        self.parent = parent
    }

    public static func baggageBuilder() -> BaggageBuilder {
        return BaggageSdkBuilder()
    }

    public func getEntries() -> [Entry] {
        var combined = entries
        if let parent = parent {
            for entry in parent.getEntries() {
                if combined[entry.key] == nil {
                    combined[entry.key] = entry
                }
            }
        }
        return Array(combined.values).compactMap { $0 }
    }

    public func getEntryValue(key: EntryKey) -> EntryValue? {
        return entries[key]??.value ?? parent?.getEntryValue(key: key)
    }

    public static func == (lhs: BaggageSdk, rhs: BaggageSdk) -> Bool {
        return lhs.parent == rhs.parent && lhs.entries == rhs.entries
    }
}

public class BaggageSdkBuilder: BaggageBuilder {
    var parent: Baggage?
    var noImplicitParent: Bool = false
    var entries = [EntryKey: Entry?]()

    public init() {
    }

    @discardableResult public func setParent(_ parent: Baggage) -> Self {
        self.parent = parent
        return self
    }

    @discardableResult public func setNoParent() -> Self {
        parent = nil
        noImplicitParent = true
        return self
    }

    @discardableResult public func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self {
        let entry = Entry(key: key, value: value, entryMetadata: metadata)
        entries[key] = entry
        return self
    }

    @discardableResult public func remove(key: EntryKey) -> Self {
        entries[key] = nil
        if parent?.getEntryValue(key: key) != nil {
            entries.updateValue(nil, forKey: key)
        }
        return self
    }

    public func build() -> Baggage {
        var parentCopy = parent
        if parent == nil && !noImplicitParent {
            parentCopy = OpenTelemetry.instance.contextManager.getCurrentContext()
        }
        return BaggageSdk(entries: entries, parent: parentCopy as? BaggageSdk)
    }
}
