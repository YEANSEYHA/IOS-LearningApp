//
//  ContentModel.swift
//  LearningApp
//
//  Created by Christopher Ching on 2021-03-03.
//

import Foundation

class ContentModel: ObservableObject {
    // list of module
    @Published var modules = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    
    // current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current Selected content and test
    @Published var currentContentSelected:Int?
    
    @Published var currentTestSelected:Int?
    
    init() {
        // Parse local data
        getLocalData()
        // download json file and parse
        getRemoteData()
        
    }
    // Mark - Data methods
    
    func getLocalData() {
        
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data")
        }
        
    }
    
    // Fetch data from the network
    func getRemoteData() {
        // String path
        let urlString = "https://codewithchris.github.io/learningapp-data/data2.json"
        
        // create a url object
        let url = URL(string: urlString)
        guard url != nil else {
            // couldn't create url
            return
        }
        
        // Create a URL Request object
        let request = URLRequest(url: url!)
        
        // Get the session and  kick off the task
        let session = URLSession.shared
      
        
        let dataTask = session.dataTask(with: request) {
            (data, response, error) in
            // check if there is an error
            guard error == nil else{
                // THere was an error
                return
            }
            
            // handle the response
            // Try to decode the json into an array of modules
            
            do {
                let decoder = JSONDecoder()
                let modules = try decoder.decode([Module].self, from: data!)
                // append parse modules into modules property
                self.modules += modules
            } catch{
                // could not parse the data
                
                
            }
            
            
        }
        
        
        // kickoff datatask
        dataTask.resume()
    }
    
    // Mark - module navigation methods
    func beginModule(_ moduleid:Int) {
        //Find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                // found the matching module
                currentModuleIndex = index
                break
            }
        }
        
    // set the current module
        currentModule = modules[currentModuleIndex]
//        lessonDescription = currentLesson.
    }
    
    func beginLesson(_ lessonIndex:Int) {
        // check that the lesson index is within range of module lesson
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }else {
            currentLessonIndex = 0
        }
        // set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson(){
        // Advance the lesson
        currentLessonIndex += 1
        // check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count{
            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }else{
            // Rest the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool{
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func beginTest(_ moduleId:Int) {
        // set the current module
        beginModule(moduleId)
        // set the current question
        currentQuestionIndex = 0
        // if there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            // set the question content
            codeText = addStyling(currentQuestion!.content)
            
            
        }
    }
    func nextQuestion(){
        // Advance the question index
            currentQuestionIndex += 1
        // check that it's within the range of question
        if currentQuestionIndex < currentModule!.test.questions.count {
            // set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            
        }else {
            // if not, the reset the properties
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    // Mark: -code styling
    private func addStyling(_ htmlString: String) -> NSAttributedString{
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        data.append(Data(htmlString.utf8))
        
        
        // Convert to attribate string
        do{
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                resultString = attributedString
        
        } catch {
            print("Couldn't turn html into attributed string")
        }
        
        return resultString
    }
}
