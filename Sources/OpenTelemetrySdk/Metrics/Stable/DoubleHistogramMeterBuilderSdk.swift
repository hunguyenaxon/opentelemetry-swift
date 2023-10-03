//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
// 

import Foundation
import OpenTelemetryApi

public class DoubleHistogramMeterBuilderSdk : DoubleHistogramBuilder, InstrumentBuilder {
    var meterProviderSharedState: MeterProviderSharedState
    
    var meterSharedState: StableMeterSharedState
    
    var type: InstrumentType = .histogram
    
    var valueType: InstrumentValueType = .double
    
    var description: String = ""
    
    var unit: String = ""
    
    var instrumentName: String
    
    init(meterProviderSharedState: inout MeterProviderSharedState, meterSharedState: inout StableMeterSharedState, name: String) {
        self.meterProviderSharedState = meterProviderSharedState
        self.meterSharedState = meterSharedState
        self.instrumentName = name
    }

    public func ofLongs() -> OpenTelemetryApi.LongHistogramBuilder {
        swapBuilder(LongHistogramMeterBuilderSdk.init)
    }
    
    public func build() -> OpenTelemetryApi.DoubleHistogram {
        buildSynchronousInstrument(DoubleHistogramMeterSdk.init)
    }
    

    
    
}
