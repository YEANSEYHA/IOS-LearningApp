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
    
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
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
    }
    
    func nextLesson(){
        // Advance the lesson
        currentLessonIndex += 1
        // check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count{
            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
        }else{
            // Rest the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool{
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
}
