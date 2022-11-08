//
//  ContentView.swift
//  coreDataMVVM
//
//  Created by dip dutt on 10/31/22.
//

import SwiftUI
import CoreData





class CoreDataViewModel:ObservableObject {
    
    
    // create continer for the data
    
    
    let Container: NSPersistentContainer
    
    @Published var saveEntities:[FruitEntity] = []
    
    
    init() {
        
        // set up container
        
        Container = NSPersistentContainer(name: "FruitsContainer")
        
        // create loading all of our data
        
        Container.loadPersistentStores { (description, error) in
            
            
            if let Error = error {
                
                
                print("an error loading in core data.\(Error)")
                
                
                
                
            }
            
            else {
                
                
                print("sucessfully load coredata")
            }
            
            
            
        }
        
        fetchFruits()
        
    }
    
    
    
    // fetch data request part
    
    
    func fetchFruits() {
        
        
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        
        
        do {
            
              saveEntities = try Container.viewContext.fetch(request)
            
            
        }
        
        
        
        catch  let error {
            
            
            print("error fetching \(error)")
            
            
        }
        
}
    
    // add data in the container.
    
    func addFruit(text:String) {
        
        
        let newFruit = FruitEntity(context: Container.viewContext)
        
        newFruit.name = text
        
        
        saveData()
        
        
    }
    
    // update data
    
    
    func updateFriutEntity(Entity: FruitEntity) {
        
        
        let currentName = Entity.name ?? ""
        
        let newname = currentName + "!"
        
        Entity.name = newname
        
        saveData()
        
    }
    
    
    func deleteFruit(indexSet:IndexSet) {
        
        
        
        guard let index = indexSet.first else {return}
        
        
        let entity = saveEntities[index]
        
        
        Container.viewContext.delete(entity)
        
        
        saveData()
        
        
        
        
        
    }
    
    
    // save the data
    
    
    func saveData() {
        
        
        do {
            
            
            try Container.viewContext.save()
            
            fetchFruits()
            
            
            
        }
        
        catch let error  {
            
            
            
            print("error  while saving the data.\(error)")
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
}











struct ContentView: View {
    
    @StateObject var vm = CoreDataViewModel()
    
    @State var textFieldText:String = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                
                
                TextField("add a fruit name", text: $textFieldText)
                    .font(.headline)
                    .foregroundColor(.mint)
                    .frame(height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                
                
                Button {
                    
                    guard !textFieldText.isEmpty else {return }
                    
                    vm.addFruit(text: textFieldText)
                    
                    
                    
                    textFieldText = ""
                    
                    
                    
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                    
                }
                
                .padding(.horizontal)
                
                List {
                    
                    ForEach(vm.saveEntities) { entity in
                        
                        
                        
                        Text(entity.name ?? "no name")
                        
                        
                            .onTapGesture {
                                
                                vm.updateFriutEntity(Entity: entity)
                                
                            
                            }
                        
                        
                        
                    }
                    
                    
                    .onDelete(perform:vm.deleteFruit)
                    
                    
                    
                }
                
                
               
                
                .listStyle(PlainListStyle())

                
                
                
                
            }
            
            .navigationTitle("Fruits")
            
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
