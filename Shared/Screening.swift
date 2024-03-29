//
//  Screening.swift
//  Daily COVID Screening
//
//  Created by Rahul Sura on 4/30/22.
//

import SwiftUI

// Main screening survey question view
struct Screening: View {
    // name and email and most recent date of filled survey to be used for screening
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("dateLastSurvey") private var dateLastSurvey : Date = Date.distantPast
    @AppStorage("isClearLastSurvey") private var isClearLastSurvey : Bool = true
    
    // day of week based on number
    let dayOfWeek: Dictionary = [1 : "Sunday", 2 : "Monday", 3 : "Tuesday", 4 : "Wednesday", 5 : "Thursday", 6 : "Friday", 7 : "Saturday"]
    
    // month of year based on number
    let monthOfYear: Dictionary = [ 1 : "January", 2 : "February", 3 : "March", 4 : "April", 5 : "May", 6 : "June", 7 : "July", 8 : "August", 9 : "September", 10 : "October", 11 : "November", 12 : "December"]
    
    // day ending based on number (like 17'th')
    let dayEndings: Dictionary = [1 : "st", 2 : "nd", 3 : "rd", 4 : "th", 5 : "th", 6 : "th", 7 : "th", 8 : "th", 9 : "th", 10 : "th", 11 : "th", 12 : "th", 13 : "th", 14 : "th", 15 : "th", 16 : "th", 17 : "th", 18 : "th", 19 : "th", 20 : "th", 21 : "st", 22 : "nd", 23 : "rd", 24 : "th", 25 : "th", 26 : "th", 27 : "th", 28 : "th", 29 : "th", 30 : "th", 31 : "st"]
    
    let yesOrNo = ["Yes","No"]
    @State private var selectedCategory = 1 // default selection is a no
    
    @Environment(\.colorScheme) var colorScheme // dark mode
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading){
                    Questions() // question list for symptom checking
                    Picker("",selection: $selectedCategory){ // segmented picker
                        ForEach(0 ..< yesOrNo.count){
                            Text(self.yesOrNo[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .frame(height: 50, alignment: .center)
                        .pickerStyle(SegmentedPickerStyle())
                    
                    if (firstName == "" || lastName == "" || email == "") { // if profile not filled out, submit is not possible
                        Text("Please ensure to go to the Profile Section to update your info before filling out your COVID Screening")
                            .foregroundColor(.red)
                    } else {
                        NavigationLink(destination: selectedCategory == 1 ? AnyView(ClearScreen()
                            .navigationBarBackButtonHidden(Bool(true))) : AnyView(NotClearScreen()
                                .navigationBarBackButtonHidden(Bool(true)))
                        ) { // submit leading to a different page
                            Text("Submit")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.system(size: 20))
                                .padding()
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke((colorScheme == .light ? .white : .black), lineWidth: 2)
                                )
                                .background(Color.blue)
                                .cornerRadius(15)
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded { // update survey date for app storage
                            dateLastSurvey = Date()
                            isClearLastSurvey = (selectedCategory != 0)
                        })
                    }
                }
                .padding()
            }
        }
        
    }
    
}

// Clear Screen survey question view
struct ClearScreen: View{
    // name and email and most recent date of filled survey to be used for screening
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("dateLastSurvey") private var dateLastSurvey : Date = Date.distantPast
    @AppStorage("isClearLastSurvey") private var isClearLastSurvey : Bool = true
    @State private var showSafari: Bool = false // for in app safari
    @Environment(\.colorScheme) var colorScheme // for dark mode
    var body: some View{
        let now = Date()
        let clear = VStack{
            (colorScheme == .light ? Image("Chapman Logo") : Image("Dark Chapman Logo"))
                .resizable()
                .frame(width: 250, height: 48, alignment: .center)
                .padding(.top)
            (Text("\(firstName) \(lastName) has a ") + Text("CLEAR")
                .foregroundColor(.green).fontWeight(.bold) + Text(" COVID Daily Health Screen for \(Screening().dayOfWeek[now.get(.weekday)] ?? "Today"), \(Screening().monthOfYear[now.get(.month)] ?? "the") \(now.get(.day))\(Screening().dayEndings[now.get(.day)] ?? "th")."))
            .font(.largeTitle)
            .padding()
            .padding(.top)
            
            HStack {
                Text("Been vaccinated? Register here.").foregroundColor(.blue)
                    .font(.title3)
                    .padding()
                    .onTapGesture {
                        showSafari.toggle()
                    }
                    .fullScreenCover(isPresented: $showSafari, content: {
                        SFSafariViewWrapper(url: URL(string: "https://web.chapman.edu/covid19vaccination")!)
                    })
                Spacer()
            }
            
            HStack{
                (Text("Resources for ") + Text("COVID-19 Vaccinations").foregroundColor(.blue))
                    .font(.title3)
                    .padding([.bottom,.horizontal])
                    .onTapGesture {
                        showSafari.toggle()
                    }
                    .fullScreenCover(isPresented: $showSafari, content: {
                        SFSafariViewWrapper(url: URL(string: "https://cusafelyback.chapman.edu/covid-19-vaccination/")!)
                    })
                Spacer()
            }
            
            HStack {
                Text("To access a Chapman campus, ensure the following are also completed:")
                    .font(.title3)
                    .padding(.horizontal)
                Spacer()
            }
            HStack {
                Text("\t• COVID-19 Safety Training via Canvas (staff, faculty, and student employees only)")
                    .font(.title3)
                .padding(.horizontal)
                Spacer()
            }
            HStack {
                Text("\t• COVID-19 Test (all who are not vaccinated)")
                    .font(.title3)
                .padding(.horizontal)
                Spacer()
            }
            
            Spacer()
        }
            .padding()
            .background(colorScheme == .light ? .white : .black)
            
            
        return ScrollView { // actual view to be returned
            VStack{
                clear
                Button(action: { // saves the image with the view declared as 'clear'
                    let image = clear.snapshot()
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }) {
                    Text("Save as Image")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke((colorScheme == .light ? .white : .black), lineWidth: 2)
                        )
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding().padding(.bottom).padding(.bottom).padding(.bottom)
            }
        }
    }
}

// Not Clear Screen
struct NotClearScreen: View{ // Similar to Clear view
    // name and email and most recent date of filled survey to be used for screening
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("dateLastSurvey") private var dateLastSurvey : Date = Date.distantPast
    @AppStorage("isClearLastSurvey") private var isClearLastSurvey : Bool = true
    @State private var showSafari: Bool = false // for in app safari
    @Environment(\.colorScheme) var colorScheme // for dark mode
    var body: some View{
        let now = Date()
        let notClear = VStack{
            (colorScheme == .light ? Image("Chapman Logo") : Image("Dark Chapman Logo"))
                .resizable()
                .frame(width: 250, height: 48, alignment: .center)
                .padding(.top)
            (Text("\(firstName) \(lastName) is ") + Text("NOT CLEAR")
                .foregroundColor(.red).fontWeight(.bold) + Text(" COVID Daily Health Screen for \(Screening().dayOfWeek[now.get(.weekday)] ?? "Today"), \(Screening().monthOfYear[now.get(.month)] ?? "the") \(now.get(.day))\(Screening().dayEndings[now.get(.day)] ?? "th")."))
            .font(.largeTitle)
            .padding()
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
            Text("Please go to the Official Daily COVID Screening Chapman email for today's date and fill out the form, so that Chapman's Health Center can help assist you further in what needs to be done.")
                .font(.title3.italic())
                .padding(.vertical)
            
            (Text("If you need further assistance, please email healthypanther@chapman.edu via your Chapman email address: ") + Text("\(email)@chapman.edu").foregroundColor(.blue))
                .font(.title3.italic())
            
            Spacer()
        }
            .padding()
            .background(colorScheme == .light ? .white : .black)
        
        return ScrollView { // actual view to be returned
            VStack{
                notClear
                Button(action: { // saves the image with the view declared as 'clear'
                    let image = notClear.snapshot()
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }) {
                    Text("Save as Image")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke((colorScheme == .light ? .white : .black), lineWidth: 2)
                        )
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding().padding(.bottom).padding(.bottom).padding(.bottom)
            }
        }
    }
}

// in case the profile info was removed after filling survey, it makes sure that profile info is complete
struct removedProfile: View{
    // name and email to be used for screening
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("email") private var email: String = ""
    @Environment(\.colorScheme) var colorScheme // dark mode
    var body: some View{
        VStack(alignment: .leading){
            (colorScheme == .light ? Image("Chapman Logo") : Image("Dark Chapman Logo"))
                .resizable()
                .frame(width: 250, height: 48, alignment: .center)
                .padding(.vertical)
                .padding(.top).padding(.top).padding(.top)
            
            Text("I'm sorry, but please make sure to have your profile fully filled out before having your screening ready")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.vertical)
            Spacer()
        }.padding()
    }
}

// Symptop Checking subview
struct Questions: View {
    @State private var showSafari: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .leading){
            (colorScheme == .light ? Image("Chapman Logo") : Image("Dark Chapman Logo"))
                .resizable()
                .frame(width: 250, height: 48, alignment: .center)
            Text("Are any of the following true for you?")
                .font(.title3)
                .padding(.vertical)
            (Text("1.").fontWeight(.bold) + Text(" I am sick with ") +
             Text("COVID-19 symptoms")
                .foregroundColor(.blue))
            .onTapGesture {
                showSafari.toggle()
            }
            .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/symptoms.html")!)
            })
            .padding(.leading)
            (Text("2.").fontWeight(.bold) + Text(" I have been notified that I am COVID-19 positive or have come in close") + Text("*").fontWeight(.bold) + Text(" contact with someone who has or is suspected of having COVID-19"))
                .padding(.horizontal)
            (Text("3.").fontWeight(.bold) + Text(" I have a ") +
             Text("temperature")
                .foregroundColor(.blue) +
             Text(" of 100.4 degrees F (or 38 C) or greater")
            )
            .onTapGesture {
                showSafari.toggle()
            }
            .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.cdc.gov/quarantine/air/reporting-deaths-illness/definitions-symptoms-reportable-illnesses.html")!)
            })
            .padding([.horizontal, .bottom])
            (Text("*").fontWeight(.bold) + Text("Close contact means that you have been within six feet of a COVID-19 positive individual for at least 15 minutes cumulative within a 24 hour period."))
                .padding(.horizontal)
            Spacer()
        }
    }
}

// extension for taking a screenshot
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = (ClearScreen().colorScheme == .light ? .white : .black)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}


// extension for getting calendar date stuff
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

// extension for making an empty date with no parameters
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct Screening_Previews: PreviewProvider {
    static var previews: some View {
        ClearScreen()
    }
}
