//
//  ContentView.swift
//  swift_day19_challenge
//
//  Created by Peter Fischer on 3/1/22.
//

import SwiftUI

enum Conversions : String, CaseIterable, Identifiable {
    case M
    case Km
    case Ft
    case Y
    case Mi
    
    var id: Conversions {self}
    
}

/*
 Conversion functions converting every type to Meters
 */
func default_m(arg : Double) -> Double {
    arg * 1.0
}

func km_to_m(arg : Double) -> Double {
    arg * 1000
}

func ft_to_m(arg : Double) -> Double {
    arg * 0.3048
}

func y_to_m(arg : Double) -> Double {
    arg * 0.9144
}

func mi_to_m(arg : Double) -> Double {
    arg * 1609.344
}

/*
 Conversion types from meters to everything else
 */
func m_to_km(arg : Double) -> Double {
    arg / 1000
}

func m_to_ft(arg : Double) -> Double {
    arg / 0.3048
}

func m_to_y(arg : Double) -> Double {
    arg / 0.9144
}

func m_to_mi(arg : Double) -> Double {
    arg / 1609.344
}

func doConversion(_ fromValue : Double,fromUnit : Conversions,toUnit : Conversions) -> String {

    let to_mters_table : [Conversions : (Double) -> Double] = [
        Conversions.M  : default_m,
        Conversions.Km : km_to_m,
        Conversions.Ft : ft_to_m,
        Conversions.Y : y_to_m,
        Conversions.Mi : mi_to_m
    ]
    
    let from_mters_table : [Conversions : (Double) -> Double] = [
        Conversions.M  : default_m,
        Conversions.Km : m_to_km,
        Conversions.Ft : m_to_ft,
        Conversions.Y : m_to_y,
        Conversions.Mi : m_to_mi
    ]
    
    if ( fromUnit == toUnit )
    {
        return fromValue.formatted()
    }
    else {
        let meters_f = to_mters_table[fromUnit] ?? default_m
        let from_meters_f = from_mters_table[toUnit] ?? default_m
        
        let ToMeters = meters_f(fromValue)
        print(ToMeters)
        
        
        return (meters_f(fromValue) * from_meters_f(fromValue)).formatted()
    }
    
}


struct ContentView: View {

    @State private var fromValue = 0.0
    @State private var fromUnit = Conversions.M
    
    private var toValue = 0.0
    @State private var toUnit = Conversions.M
    
    let doubleFrmt : NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter
    }()
    
    @FocusState private var inputIsFocused : Bool

    
    var body: some View {

        NavigationView {
            Form {
                
                Section {
                    TextField("FromValue", value: $fromValue, formatter: doubleFrmt)
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    inputIsFocused = false
                                }
                            }
                        }
                        .focused($inputIsFocused)
                } header: {
                    Text("Input Value")
                }
                
                Section {
                    Text("From")
                    Picker("FromUnits", selection: $fromUnit) {
                        ForEach(Conversions.allCases) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    Text("To")
                    Picker("ToUnits", selection: $toUnit) {
                        ForEach(Conversions.allCases) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    
                }
                
                Section {
                    Text("\(doConversion(fromValue, fromUnit: fromUnit, toUnit: toUnit))")
                } header: {
                    Text("Result")
                }
                
            }.navigationTitle("Unit Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}
