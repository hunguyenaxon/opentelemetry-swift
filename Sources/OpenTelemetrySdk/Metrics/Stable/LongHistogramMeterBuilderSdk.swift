//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation
import OpenTelemetryApi

public class LongHistogramMeterBuilderSdk : LongHistogramBuilder, InstrumentBuilder {
    
    var meterProviderSharedState: MeterProviderSharedState
    
    var meterSharedState: StableMeterSharedState
    
    var type: InstrumentType = .histogram
    
    var valueType: InstrumentValueType = .long
    
    var description: String
    
    var unit: String
    
    var instrumentName: String
    
    internal init(meterProviderSharedState: MeterProviderSharedState, meterSharedState: StableMeterSharedState, instrumentName: String, description: String, unit: String) {
        self.meterProviderSharedState = meterProviderSharedState
        self.meterSharedState = meterSharedState
        self.description = description
        self.unit = unit
        self.instrumentName = instrumentName
    }
    
    
    public func build() -> OpenTelemetryApi.LongHistogram {
        buildSynchronousInstrument(LongHistogramMeterSdk.init)
    }
    

    
    
}
