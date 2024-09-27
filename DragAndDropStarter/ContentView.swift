//
//  ContentView.swift
//  DragAndDropStarter
//
//  Created by A'zamjon Abdumuxtorov on 27/09/24.
//

import SwiftUI
import Algorithms

struct ContentView: View {
    @State private var toDoTasks:[String] = ["@Observable Migration","Keyframe Animation" ,"Migrate to swift Data"]
    @State private var inProgressTasks :[String] = []
    @State private var doneTasks:[String] = []
    
    @State private var isToDoTargeted = false
    @State private var isProgressTargeted = false
    @State private var isDoneTargeted = false
    
    var body: some View {
        HStack {
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for: String.self) { dropTasks, location in
                    for task in dropTasks {
                        inProgressTasks.removeAll{$0 == task}
                        doneTasks.removeAll{$0 == task}
                    }
                    let totalTasks = toDoTasks + dropTasks
                    toDoTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            KanbanView(title: "Progress", tasks: inProgressTasks, isTargeted: isProgressTargeted)
                .dropDestination(for: String.self) { dropTasks, location in
                    for task in dropTasks {
                        toDoTasks.removeAll{$0 == task}
                        doneTasks.removeAll{$0 == task}
                    }
                    let totalTasks = inProgressTasks + dropTasks
                    inProgressTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isProgressTargeted = isTargeted
                }

            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for: String.self) { dropTasks, location in
                    for task in dropTasks {
                        toDoTasks.removeAll{$0 == task}
                        inProgressTasks.removeAll{$0 == task}
                    }
                    let totalTasks = doneTasks + dropTasks
                    doneTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isDoneTargeted = isTargeted
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        
}


struct KanbanView:View {
    let title:String
    let tasks:[String]
    let isTargeted:Bool
    var body: some View {
        VStack(alignment:.leading){
            Text(title)
                .font(.footnote.bold())
            ZStack{
                RoundedRectangle(cornerRadius:12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? Color(.tintColor).opacity(0.15): Color(.secondarySystemFill))
                
                VStack(alignment:.leading,spacing: 12){
                    ForEach(tasks,id: \.self){ task in
                        Text(task)
                            .padding(12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 1,x: 1,y: 1)
                            .draggable(task)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}
